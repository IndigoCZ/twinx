class Person < ActiveRecord::Base
  attr_accessible :born, :county_id, :first_name, :full_name, :id_string, :last_name, :yob, :gender
  belongs_to :county
  validates_presence_of :first_name, :last_name, :yob, :gender, :county
  validates :yob, :numericality => { only_integer:true , greater_than:1900, less_than:Time.now.year } # Make sure we reboot once a year :-)
  validates_inclusion_of :gender, in:["male","female"]

  def display_name
    "#{first_name} #{last_name}"
  end
end
