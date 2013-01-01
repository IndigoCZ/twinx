class Team < ActiveRecord::Base
  attr_accessible :county_id, :race_id
  belongs_to :county
  belongs_to :race
  has_many :participants
  validates_presence_of :race, :county
  before_destroy :check_dependencies

  scope :for_race, lambda { |race| where(race_id:race.id).includes(:county) }

  def check_dependencies
    if participants.count > 0
      errors.add(:base, "cannot be deleted while participants exist")
      return false
    end
  end

  def title
    county.title
  end

end
