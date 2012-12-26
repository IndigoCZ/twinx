class Constraint < ActiveRecord::Base
  attr_accessible :category_id, :restrict, :value
  belongs_to :category
  validates_presence_of :restrict, :value
end
