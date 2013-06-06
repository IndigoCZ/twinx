class Constraint < ActiveRecord::Base
  attr_accessible :category_id, :restrict, :string_value, :integer_value, :value
  belongs_to :category
  validates_presence_of :restrict
  validates_inclusion_of :restrict, in:["max_age","min_age","gender"]
  validates_presence_of :integer_value, :if => :numeric_restriction?
  validates_presence_of :string_value, :if => :string_restriction?
  after_create :cap_category_difficulty
  after_update :recalculate_category_difficulty
  after_destroy :recalculate_category_difficulty
  MAX_DIFFICULTY=100

  def cap_category_difficulty
    if (self.category.difficulty.nil?) || (self.category.difficulty > self.difficulty)
      self.category.update_attributes(difficulty:self.difficulty)
    end
  end

  def recalculate_category_difficulty
    self.category.recalculate_difficulty
  end

  def numeric_restriction?
    restrict == "max_age" || restrict == "min_age"
  end

  def string_restriction?
    restrict == "gender"
  end

  def value
    if numeric_restriction?
      integer_value
    else
      string_value
    end
  end

  def value=(val)
    if numeric_restriction?
      self.integer_value=val
    else
      self.string_value=val
    end
  end

  def description
    "#{restrict}: #{value}"
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
