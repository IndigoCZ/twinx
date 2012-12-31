class Category < ActiveRecord::Base
  attr_accessible :race_id, :title, :constraints_attributes
  belongs_to :race
  has_many :participants
  has_many :constraints
  validates_presence_of :title, :race
  before_destroy :check_dependencies
  accepts_nested_attributes_for :constraints,:reject_if => :all_blank, allow_destroy: true

  scope :violate_max_age,   lambda { |age| includes(:constraints).where("constraints.restrict = 'max_age' AND constraints.integer_value < ?", age) }
  scope :violate_min_age,   lambda { |age| includes(:constraints).where("constraints.restrict = 'min_age' AND constraints.integer_value > ?", age) }
  scope :excluding_ids, lambda { |ids| where(['categories.id NOT IN (?)', ids]) if ids.any? }
  scope :for_age,    lambda { |age| excluding_ids(violate_min_age(age).map(&:id)+violate_max_age(age).map(&:id)) }
  scope :for_gender, lambda { |gender| includes(:constraints).where("constraints.restrict = 'gender' AND constraints.string_value = ?", gender) }

  def check_dependencies
    if participants.count > 0
      errors.add(:base, "cannot be deleted while participants exist")
      return false
    end
  end
  def difficulty
    rval=Constraint::MAX_DIFFICULTY
    constraints.each do |constraint|
      rval=constraint.difficulty if rval > constraint.difficulty
    end
    rval
  end
  def restriction
    restrict_gender=""
    restrict_age=""
    constraints.each do |c|
      case c.restrict
      when "max_age"
        restrict_age="#{c.integer_value}-"
      when "min_age"
        restrict_age="#{c.integer_value}+"
      when "gender"
        restrict_gender=c.string_value[0].upcase
      end
    end
    restrict_gender+restrict_age
  end
end
