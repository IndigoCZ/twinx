class Category < ActiveRecord::Base
  attr_accessible :race_id, :title
  belongs_to :race
  has_many :participants
  validates_presence_of :title, :race
  before_destroy :check_dependencies

  def check_dependencies
    if participants.count > 0
      errors.add(:base, "cannot be deleted while participants exist")
      return false
    end
  end
end
