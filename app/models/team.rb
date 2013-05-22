class Team < ActiveRecord::Base
  attr_accessible :county_id, :race_id
  belongs_to :county
  belongs_to :race
  has_many :participants
  has_many :results, through: :participants
  validates_presence_of :race, :county
  before_destroy :check_dependencies

  scope :for_race, lambda { |race| where(race_id:race.id).includes(:county) }

  def check_dependencies
    if participants.count > 0
      errors.add(:base, "cannot be deleted while participants exist")
      return false
    end
  end

  def self.first_or_create_for_race_and_county(race,county)
    self.where(race_id:race,county_id:county).first_or_create
  end

  def title
    county.title
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
