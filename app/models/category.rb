# encoding: UTF-8
class Category < ActiveRecord::Base
  attr_accessible :race_id, :title, :constraints_attributes, :code, :sort_order
  belongs_to :race
  has_many :participants
  has_many :results, through: :participants
  has_many :constraints
  validates_presence_of :title, :race
  before_destroy :check_dependencies
  accepts_nested_attributes_for :constraints,:reject_if => :all_blank, allow_destroy: true

  scope :violate_max_age,   lambda { |age| includes(:constraints).where("constraints.restrict = 'max_age' AND constraints.integer_value < ?", age) }
  scope :violate_min_age,   lambda { |age| includes(:constraints).where("constraints.restrict = 'min_age' AND constraints.integer_value > ?", age) }
  scope :excluding_ids, lambda { |ids| where(['categories.id NOT IN (?)', ids]) if ids.any? }
  scope :for_age,    lambda { |age| excluding_ids(violate_min_age(age).map(&:id)+violate_max_age(age).map(&:id)) }
  scope :for_gender, lambda { |gender| includes(:constraints).where("constraints.restrict = 'gender' AND constraints.string_value = ?", gender) }
  scope :for_race, lambda { |race| where(race_id:race.id) }

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

  def dnfs
    participants.includes(:result).where("results.id IS NULL")
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

  def self.create_by_code(race,code)
    details=self.categories_from_ruleset[code]
    cat=Category.create(race_id:race.id,title:details["title"],code:code,sort_order:details["sort_order"])
    Constraint.create(category_id:cat.id,restrict:"gender",value:details["gender"])
    Constraint.create(category_id:cat.id,restrict:"max_age",value:details["max_age"]) if details.has_key? "max_age"
    Constraint.create(category_id:cat.id,restrict:"min_age",value:details["min_age"]) if details.has_key? "min_age"
    cat
  end
  def self.categories_from_ruleset
    @categories_from_ruleset||=YAML.load_file('config/rulesets/orel2012.yml')["categories"]
  end
end
