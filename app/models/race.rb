class Race < ActiveRecord::Base
  attr_accessible :held_on, :title
  validates_presence_of :title, :held_on
  has_many :categories
  has_many :teams
  has_many :participants, :through => :categories
  has_many :results, :through => :participants
  before_destroy :check_dependencies

  def check_dependencies
    if categories.count > 0
      errors.add(:base, "cannot be deleted while categories exist")
      return false
    end
    if teams.count > 0
      errors.add(:base, "cannot be deleted while teams exist")
      return false
    end
  end
end
