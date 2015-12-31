class Team < ActiveRecord::Base
  extend ModelDependencyHandling
  #attr_accessible :county_id, :race_id
  belongs_to :county
  belongs_to :race
  belongs_to :team_type
  has_many :participants
  has_many :results, through: :participants
  validates_presence_of :race, :title
  block_deletion_on_dependency :participants

  scope :for_race, lambda { |race| where(race_id:race.id).includes(:county) }


  def self.for_participant_form(race,county,team_type)
    #county=County.where(title:title).first_or_create
    team=self.where(race_id:race,county:county,team_type:team_type).first_or_create
    unless team.title
      team.title="#{team_type.title} #{county.title}"
      team.save
    end
    return team
  end

  def dnfs
    participants.includes(:result).where("results.id IS NULL").references(:result)
  end

  def points(limit=nil)
    limit||=point_array.size
    point_array.shift(limit.to_i).sum
  end

  def point_array
    self.results.collect(&:points).sort.reverse
  end
end
