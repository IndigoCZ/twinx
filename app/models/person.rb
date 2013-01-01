class Person < ActiveRecord::Base
  attr_accessible :born, :county_id, :first_name, :full_name, :id_string, :last_name, :yob, :gender
  belongs_to :county
  validates_presence_of :first_name, :last_name, :yob, :gender, :county
  validates :yob, :numericality => { only_integer:true , greater_than:1900, less_than:Time.now.year } # Make sure we reboot once a year :-)
  validates_inclusion_of :gender, in:["male","female"]

  def display_name
    "#{first_name} #{last_name}"
  end

  def self.lookup_or_create(hash)
    lookup=Person.where(hash.select { |k,v| ["first_name", "last_name", "gender", "yob", "county_id"].include? k })
    if lookup.size > 1
      if hash["id_string"]
        if lookup.where("id_string"=>hash["id_string"]).size > 0
          return lookup.where("id_string"=>hash["id_string"]).first
        end
      end
      raise "Couldn't determine which person from #{lookup} to choose"
    elsif lookup.size == 1
      lookup.first
    else
      Person.create(hash)
    end
  end
end
