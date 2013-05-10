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
    return nil if time_msec.nil?
    "#{time_min}:#{time_sec}.#{time_fract}"
  end

  def time=(val)
    if val.respond_to? :has_key?
      msec=val["fract"]
      sec=val["sec"]
      min=val["min"]
    elsif val.respond_to? :split
      min,sec,msec=val.split(/[:,.]/)
    end
    msec=msec.ljust(3,"0").to_i
    sec=sec.to_i
    min=min.to_i

    msec=((min*60000)+(sec*1000)+msec)
    if msec > 0
      self.time_msec=msec
    else
      self.time_msec=nil
    end
  end

  def time_min
    return "0" if time_msec.nil?
    (time_msec / 60000).to_s
  end

  def time_sec
    return "00" if time_msec.nil?
    ((time_msec / 1000) % 60).to_s.rjust(2,"0")
  end

  def time_fract
    return "000" if time_msec.nil?
    (time_msec % 1000).to_s.rjust(3,"0")
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
