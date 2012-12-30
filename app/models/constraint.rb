class Constraint < ActiveRecord::Base
  attr_accessible :category_id, :restrict, :string_value, :integer_value
  belongs_to :category
  validates_presence_of :restrict
  validates_inclusion_of :restrict, in:["max_age","min_age","gender"]
  validates_presence_of :integer_value, :if => :numeric_restriction?
  validates_presence_of :string_value, :if => :string_restriction?
  MAX_DIFFICULTY=100

  def numeric_restriction?
    restrict == "max_age" || restrict == "min_age"
  end

  def string_restriction?
    restrict == "gender"
  end

  def difficulty
    case restrict
    when "max_age"
      integer_value
    when "min_age"
      (MAX_DIFFICULTY - integer_value)
    else
      MAX_DIFFICULTY
    end
  end
end
