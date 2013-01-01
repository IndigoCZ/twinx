class Participant < ActiveRecord::Base
  attr_accessible :category_id, :starting_no, :team_id, :person_id
  belongs_to :person
  belongs_to :team, counter_cache:true
  belongs_to :category, counter_cache:true
  has_one :race, through: :category
  has_one :result
  validates :starting_no, :numericality => { only_integer:true }
  validates_presence_of :person, :team, :category, :starting_no
  before_destroy :clean_result

  scope :for_race, lambda { |race| includes([:category,{team: :county},:person]).where("categories.race_id = ?", race.id) }
  scope :by_team_id, lambda { |team| where(team_id:team) }
  scope :by_category_id, lambda { |cat| where(category_id:cat) }

  def clean_result
    result.destroy if result
  end

  def display_name
    person.display_name
  end

  def self.filter_by(string)
    column,val=string.split("_")
    self.send("by_#{column}_id",val)
  end

  def self.sort_by(column=nil)
    case column
    when "team"
      "counties.title"
    when "category"
      "categories.title"
    when "name"
      "people.last_name"
    else
      "starting_no"
    end
  end
end
