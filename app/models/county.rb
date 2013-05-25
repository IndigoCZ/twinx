class County < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :teams
  has_many :people
  before_destroy :check_dependencies

  scope :finder, lambda { |q| where("title like :q", q: "%#{q}%") }

  def check_dependencies
    if people.count > 0
      errors.add(:base, "cannot be deleted while people exist")
      return false
    end
    if teams.count > 0
      errors.add(:base, "cannot be deleted while teams exist")
      return false
    end
  end
end
