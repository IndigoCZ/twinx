class Participant < ActiveRecord::Base
  attr_accessible :category_id, :starting_no, :team_id, :person_id
  belongs_to :person
  belongs_to :team
  belongs_to :category
  validates :starting_no, :numericality => { only_integer:true }
  validates_presence_of :person, :team, :category, :starting_no
end
