class Person < ActiveRecord::Base
  extend ModelDependencyHandling
  #attr_accessible :born, :county_id, :first_name, :full_name, :id_string, :last_name, :yob, :gender
  belongs_to :county
  has_many :participants
  validates_presence_of :first_name, :last_name, :yob, :gender, :county
  validates :yob, :numericality => { only_integer:true , greater_than:1900, less_than:Time.now.year } # Make sure we reboot once a year :-)
  validates_inclusion_of :gender, in:["male","female"]
  #validates_uniqueness_of :id_string, allow_nil:true
  before_validation :add_year_to_birthday
  block_deletion_on_dependency :participants

  def display_name
    "#{first_name} #{last_name}"
  end

  def merge(other_person)
    self.id_string=other_person.id_string if other_person.id_string
    self.born=other_person.born if other_person.born
    self.participants+=other_person.participants
    other_person.delete
    self.save if self.changed?
  end
  def find_dupes
    Person.where(first_name:first_name,last_name:last_name,gender:gender,yob:yob,county_id:county_id).where("id != ?", id)
  end
  def dedup
    find_dupes.each do |dupe|
      self.merge(dupe)
    end
  end

  def add_year_to_birthday
    if born && yob
      self.born=Date.new(yob.to_i,born.month,born.day)
    end
  end
end
