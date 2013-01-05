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
    details=self.details_for_code(code)
    cat=Category.create(race_id:race.id,title:details[:title],code:code,sort_order:details[:sort_order])
    Constraint.create(category_id:cat.id,restrict:"gender",value:details[:gender])
    Constraint.create(category_id:cat.id,restrict:"max_age",value:details[:max_age]) if details.has_key? :max_age
    Constraint.create(category_id:cat.id,restrict:"min_age",value:details[:min_age]) if details.has_key? :min_age
    cat
  end
  def self.details_for_code(code)
    case code
    when "D7"
      {title:"Předškolní děti-dívky",gender:"female",max_age:7,sort_order:10}
    when "C7"
      {title:"Předškolní děti-hoši",gender:"male",max_age:7,sort_order:20}
    when "D9"
      {title:"Nejmladší žákyně II",gender:"female",max_age:9,sort_order:30}
    when "C9"
      {title:"Nejmladší žáci II",gender:"male",max_age:9,sort_order:40}
    when "D11"
      {title:"Nejmladší žákyně",gender:"female",max_age:11,sort_order:50}
    when "C11"
      {title:"Nejmladší žáci",gender:"male",max_age:11,sort_order:60}
    when "D13"
      {title:"Mladší žákyně",gender:"female",max_age:13,sort_order:70}
    when "C13"
      {title:"Mladší žáci",gender:"male",max_age:13,sort_order:80}
    when "D15"
      {title:"Starší žákyně",gender:"female",max_age:15,sort_order:90}
    when "C15"
      {title:"Starší žáci",gender:"male",max_age:15,sort_order:100}
    when "D17"
      {title:"Dorostenky",gender:"female",max_age:17,sort_order:110}
    when "C17"
      {title:"Dorostenci",gender:"male",max_age:17,sort_order:120}
    when "D19"
      {title:"Juniorky",gender:"female",max_age:19,sort_order:130}
    when "C19"
      {title:"Junioři",gender:"male",max_age:19,sort_order:140}
    when "Z35"
      {title:"Ženy B",gender:"female",min_age:35,sort_order:150}
    when "Z"
      {title:"Ženy A",gender:"female",sort_order:160}
    when "V60"
      {title:"Muži D",gender:"male",min_age:60,sort_order:170}
    when "V50"
      {title:"Muži C",gender:"male",min_age:50,sort_order:180}
    when "V40"
      {title:"Muži B",gender:"male",min_age:40,sort_order:190}
    when "M"
      {title:"Muži A",gender:"male",sort_order:200}
    end
  end
end
