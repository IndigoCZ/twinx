class Result < ActiveRecord::Base
  attr_accessible :position, :time_msec, :participant_id
  belongs_to :participant
  validates_presence_of :participant, :position
  validates :position, :time_msec, :numericality => { only_integer:true }, allow_nil:true

  def time
    time_msec
  end
end
