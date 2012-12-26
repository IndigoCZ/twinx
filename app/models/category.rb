class Category < ActiveRecord::Base
  attr_accessible :race_id, :title, :constraints_attributes
  belongs_to :race
  has_many :participants
  has_many :constraints
  validates_presence_of :title, :race
  before_destroy :check_dependencies
  accepts_nested_attributes_for :constraints,:reject_if => :all_blank, allow_destroy: true

  def check_dependencies
    if participants.count > 0
      errors.add(:base, "cannot be deleted while participants exist")
      return false
    end
  end
end
