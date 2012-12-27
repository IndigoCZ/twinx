class Participant < ActiveRecord::Base
  attr_accessible :category_id, :starting_no, :team_id, :person_id
  belongs_to :person
  belongs_to :team
  belongs_to :category
  has_one :race, through: :category
  has_one :result
  validates :starting_no, :numericality => { only_integer:true }
  validates_presence_of :person, :team, :category, :starting_no
  before_destroy :clean_result

  def clean_result
    result.destroy if result
  end

  def display_name
    person.display_name
  end
end
