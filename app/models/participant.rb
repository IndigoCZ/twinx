# encoding: UTF-8
class Participant < ActiveRecord::Base
  extend SortableTable
  belongs_to :person
  belongs_to :team, counter_cache:true
  belongs_to :category, counter_cache:true
  has_one :race, through: :category
  has_one :result
  validates :starting_no, :numericality => { only_integer:true }
  validates_presence_of :person, :team, :category, :starting_no
  before_destroy :clean_result
  validate :starting_no_unique_for_race

  scope :for_race, lambda { |race| includes([:category,{team: :county},:person]).where("categories.race_id = ?", race.id).references(:category) }
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

  def self.find_for_result(race,starting_no)
    self.includes(:race).where("races.id = ?",race.id).references(:race).where(starting_no:starting_no).first
  end

  def self.group_by(column=nil)
    case column
    when "team"
      "teams.title"
    else
      "categories.sort_order"
    end
  end

  def self.sort_attrs
    {
      "team"=>"teams.title",
      "category"=>"categories.sort_order",
      "name"=>"people.last_name",
      "default"=>"starting_no"
    }
  end
end
