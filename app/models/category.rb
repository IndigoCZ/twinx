# encoding: UTF-8
class Category < ActiveRecord::Base
  @@ruleset_file=nil
  @@categories_from_ruleset=nil
  extend ModelDependencyHandling
  belongs_to :race
  has_many :participants
  has_many :results, through: :participants
  has_many :constraints, :dependent => :destroy
  validates_presence_of :title, :race
  block_deletion_on_dependency :participants
  accepts_nested_attributes_for :constraints,:reject_if => :all_blank, allow_destroy: true
  before_validation :recalculate_difficulty

  scope :for_race, lambda { |race| includes(:constraints).where(race_id:race.id) }

  def calculate_difficulty
    rval=Constraint::MAX_DIFFICULTY
    self.constraints.each do |constraint|
      rval=constraint.difficulty if rval > constraint.difficulty
    end
    rval
  end
  def recalculate_difficulty
    self.difficulty=calculate_difficulty
  end

  def dnfs
    participants.includes(:result).where("results.id IS NULL").references(:result)
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

  def self.first_or_create_by_code(race,code)
    cats=self.where(race_id:race.id,code:code)
    return cats.first unless cats.empty?
    details=self.categories_from_ruleset[code]
    cat=Category.create(race_id:race.id,title:details["title"],code:code,sort_order:details["sort_order"])
    Constraint.create(category_id:cat.id,restrict:"gender",value:details["gender"]) if details.has_key? "gender"
    Constraint.create(category_id:cat.id,restrict:"max_age",value:details["max_age"]) if details.has_key? "max_age"
    Constraint.create(category_id:cat.id,restrict:"min_age",value:details["min_age"]) if details.has_key? "min_age"
    cat
  end
  def self.categories_from_ruleset
    @@categories_from_ruleset||=YAML.load_file(self.ruleset_file)["categories"]
  end
  def self.set_ruleset_file(ruleset)
    @@ruleset_file=ruleset
    @@categories_from_ruleset=nil
  end
  def self.ruleset_file
    @@ruleset_file||'config/rulesets/orel2012.yml'
  end
end
