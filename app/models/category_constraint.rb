class CategoryConstraint < ActiveRecord::Base
  attr_accessible :category_id, :type, :value
  belongs_to :category
  validates_presence_of :type, :value, :category
end
