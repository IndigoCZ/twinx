# encoding: UTF-8
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
  validate :starting_no_unique_for_race

  scope :for_race, lambda { |race| includes([:category,{team: :county},:person]).where("categories.race_id = ?", race.id) }
  scope :by_team_id, lambda { |team| where(team_id:team) }
  scope :by_category_id, lambda { |cat| where(category_id:cat) }

  def clean_result
    result.destroy if result
  end

  def display_name
    person.display_name
  end

  def starting_no_unique_for_race
    if self.race
      lookup=self.race.participants.where(starting_no:(self.starting_no))
      if lookup.size > 0
        errors.add(:starting_no, "Startovní číslo musí být pro závod unikátní") unless lookup.first.id == self.id
      end
    end
  end

  def attr_for_csv(column)
    case column
    when "starting_no"
      starting_no
    when "first_name"
      person.first_name
    when "last_name"
      person.last_name
    when "full_name"
      person.full_name
    when "gender"
      person.gender
    when "yob"
      person.yob
    when "team"
      team.title
    when "category"
      category.code
    when "position"
      if result
        result.position
      else
        "DNF"
      end
    when "time"
      if result && result.time
        result.time
      else
        nil
      end
    when "born"
      person.born
    when "competing"
      true
    when "id_string"
      person.id_string
    end
  end

  def self.find_for_result(race,starting_no)
    self.includes(:race).where("races.id = ?",race.id).where(starting_no:starting_no).first
  end

  def self.filter_by(string)
    column,val=string.split("_")
    self.send("by_#{column}_id",val)
  end

  def self.group_by(column=nil)
    case column
    when "team"
      "counties.title"
    else
      "categories.sort_order"
    end
  end

  def self.sort_by(column=nil)
    case column
    when "team"
      "counties.title"
    when "category"
      "categories.sort_order"
    when "name"
      "people.last_name"
    else
      "starting_no"
    end
  end

  def self.to_csv(race)
    header=%w[starting_no first_name last_name full_name gender yob team category position time born competing id_string]
    CSV.generate do |csv|
      csv << header
      self.for_race(race).each do |participant|
        row=[]
        header.each do |col|
          row<<participant.attr_for_csv(col)
        end
        csv << row
      end
    end
  end
end
