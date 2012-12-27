class Constraint < ActiveRecord::Base
  attr_accessible :category_id, :restrict, :string_value, :integer_value
  belongs_to :category
  validates_presence_of :restrict
end
