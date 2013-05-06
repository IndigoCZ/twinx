class Person < ActiveRecord::Base
  attr_accessible :born, :county_id, :first_name, :full_name, :id_string, :last_name, :yob, :gender
  belongs_to :county
  has_many :participants
  validates_presence_of :first_name, :last_name, :yob, :gender, :county
  validates :yob, :numericality => { only_integer:true , greater_than:1900, less_than:Time.now.year } # Make sure we reboot once a year :-)
  validates_inclusion_of :gender, in:["male","female"]
  #validates_uniqueness_of :id_string, allow_nil:true
  before_validation :add_year_to_birthday

  def display_name
    "#{first_name} #{last_name}"
  end

  def self.required_params
    ["first_name", "last_name", "gender", "yob", "county_id"]
  end

  def self.lookup_or_create(hash)
    required_params.each do |rp|
      raise "Parameter #{rp} missing from lookup hash" unless hash.has_key? rp
    end
    found=nil
    lookup=Person.where(hash.select { |k,v| required_params.include? k })
    if lookup.size == 1
      found=lookup.first
    elsif lookup.size > 1
      if hash["id_string"]
        if Person.where("id_string"=>hash["id_string"]).size > 0 # Unique constraint on id_string
          found=lookup.where("id_string"=>hash["id_string"]).first
        end
      elsif hash["born"]
        if lookup.where("born"=>hash["born"]).size == 1
          found=lookup.where("born"=>hash["born"]).first
        end
      end
      raise "Couldn't determine which person from #{lookup.map{|x| x.display_name }.join(",")} to choose" unless found
    else
      found=Person.create(hash)
    end
    if found.complement_record_from_hash(hash)
      found
    else
      puts found.errors.inspect
      raise "Failed to complement record!"
    end
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

  def complement_record_from_hash(hash)
    if hash["born"]
      if self.born
        logger.warn "Mismatch on birthday! #{self.born} != #{hash["born"]}" unless self.born.to_s == hash["born"] # This will probably blow up a lot
      end
      self.born=hash["born"]
    end
    if hash["id_string"]
      if self.id_string
        logger.warn "Mismatch on id_string! #{self.id_string} != #{hash["id_string"]}" unless self.id_string == hash["id_string"]
      end
      self.id_string=hash["id_string"]
    end
    self.full_name=hash["full_name"] if hash["full_name"]
    self.save
  end

  def add_year_to_birthday
    if born && yob
      self.born=Date.new(yob.to_i,born.month,born.day)
    end
  end
end
