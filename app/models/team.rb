class Team < ActiveRecord::Base
  extend ModelDependencyHandling
  attr_accessible :county_id, :race_id
  belongs_to :county
  belongs_to :race
  has_many :participants
  has_many :results, through: :participants
  validates_presence_of :race, :title
  block_deletion_on_dependency :participants

  scope :for_race, lambda { |race| where(race_id:race.id).includes(:county) }


  def self.with_race_and_title(race,title)
    county=County.where(title:title).first_or_create
    team=self.where(race_id:race,title:title).first_or_create
    unless team.county==county
      team.county=county
      team.save
    end
    return team
  end

  def dnfs
    participants.includes(:result).where("results.id IS NULL")
  end

  def points(limit=nil)
    if limit
      self.results.collect(&:points).sort.reverse.shift(limit.to_i).sum
    else
      self.results.sum(&:points)
    end
  end
end
