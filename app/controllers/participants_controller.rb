class ParticipantsController < ApplicationController
  def index
    @participants=@current_race.participants
  end
  def new
    @person=Person.new
    @participant=Participant.new
    @county=County.new
    # Temporary code
    @categories=Category.where(race_id:@current_race.id)
  end
  def create
    @county=County.find_or_create_by_title(params[:county][:title]) # Is this dangerous?
    person_details=params[:person]
    person_details[:county_id]=@county.id
    @person=Person.where(person_details).first_or_create
    logger.info(@person.inspect)
    @team=Team.where(race_id:@current_race.id,county_id:@county.id).first_or_create
    participant_details=params[:participant]
    participant_details[:team_id]=@team.id
    participant_details[:person_id]=@person.id
    @participant=Participant.new(participant_details)
    if @participant.save
      redirect_to race_participants_url(@current_race), notice:'Participant was successfully created.'
    else
      @categories=Category.where(race_id:@current_race.id)
      render action: "new"
    end
  end
end
