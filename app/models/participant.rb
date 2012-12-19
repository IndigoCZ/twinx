class Participant < ActiveRecord::Base
  attr_accessible :category_id, :starting_no, :team_id, :person_id
  belongs_to :person
  belongs_to :team
  belongs_to :category
  has_one :race, through: :category
  validates :starting_no, :numericality => { only_integer:true }
  validates_presence_of :person, :team, :category, :starting_no

  def display_name
    person.display_name
  end
end
