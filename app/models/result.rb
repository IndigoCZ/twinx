class Result < ActiveRecord::Base
  attr_accessible :position, :time, :participant_id, :starting_no
  attr_writer :race, :starting_no
  belongs_to :participant
  validates_presence_of :participant, :position
  validates :position, :time_msec, :numericality => { only_integer:true }, allow_nil:true
  before_validation :participant_enforcement

  scope :for_race, lambda { |race| includes(participant:[:category,{team: :county},:person]).where("categories.race_id = ?", race.id) }
  scope :by_team_id, lambda { |team| includes(:participant).where("participants.team_id = ?", team) }
  scope :by_category_id, lambda { |cat| includes(:participant).where("participants.category_id = ?", cat) }

  def time
    Duration.from_ms(time_msec)
  end

  def time=(val)
    if val.respond_to? :has_key?
      self.time_msec=Duration.from_hash(val).to_i
    elsif val.respond_to? :split
      self.time_msec=Duration.from_string(val).to_i
    end
  end

  def points
    case position
    when 1
      12
    when 2..10
      (12 - position)
    else
      1
    end
  end

  def starting_no
    if participant
      participant.starting_no
    else
      @starting_no
    end
  end

  def race
    if participant
      participant.race
    else
      @race
    end
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
      "categories.sort_order"
    when "name"
      "people.last_name"
    else
      "position"
    end
  end

  def participant_lookup(allow_duplicate=false)
    if race && starting_no
      lookup=Participant.find_for_result(race,starting_no)
      if lookup
        if lookup.result.nil? || allow_duplicate || lookup.result==self
          return lookup
        end
      end
    end
    nil
  end

  def participant_enforcement
    return participant if participant
    self.participant=participant_lookup
  end
end
