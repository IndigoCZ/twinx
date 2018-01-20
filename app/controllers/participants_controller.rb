# encoding: UTF-8
class ParticipantsController < ApplicationController
  def index
    @participants=group_sort_and_filter_class_for_current_race(Participant)
    respond_to do |format|
      format.html
      format.pdf
    end
  end
  def new
    if params.has_key?(:prefill_person_id)
      @person=Person.find(params[:prefill_person_id])
    else
      @person=Person.new
      @person.gender="male"
      @person.yob="2000"
      @person.county_id=session[:last_county_id]
    end
    @participant=Participant.new
    if params[:prefill_starting_no]
      @participant.starting_no=params[:prefill_starting_no]
    else
      @participant.starting_no=session[:last_starting_no].to_i+1
    end
    @previous_participant=Participant.find(previous_id) if previous_id

    @team=Team.new
    @team.team_type_id=session[:last_team_type_id]||TeamType.first.id
  end
  def create
    logger.info "Prepare Person"
    person_params=extract_person_params(params[:participant].delete(:person))
    @person=Person.new(person_params)
    handle_new_county(@person,person_params)

    team_params=params[:participant].delete(:team)
    @team_type=TeamType.find(team_params["team_type_id"])

    logger.info "Prepare Participant"
    @participant=Participant.new(participant_params)

    logger.info "Prepare Team"
    @team=Team.for_participant_form(@current_race,@person.county,@team_type)

    logger.info "Try to save Person"
    if @person.save
      @person.dedup
      @participant.team_id=@team.id
      @participant.person_id=@person.id
      session[:last_county_id]=@person.county.id
      session[:last_team_type_id]=@team_type.id
      logger.info "Try to save Participant"
      if @participant.save
        session[:last_starting_no]=@participant.starting_no
        redirect_to new_race_participant_url(@current_race,previous_id:@participant.id), notice:'Účastník byl úspěšně vytvořen.'
        return
      else
        logger.info "Failed to save Participant"
      end
    else
      logger.info "Failed to save Person"
    end
    render action: "new"
  end
  def show
    @participant=Participant.find(params[:id])
  end
  def edit
    @participant=Participant.find(params[:id])
    @person=@participant.person
    @team=@participant.team
  end
  def update
    @participant=Participant.find(params[:id])
    person_params=extract_person_params(params[:participant].delete(:person))
    @person=Person.new(person_params)
    handle_new_county(@person,person_params)

    team_params=params[:participant].delete(:team)
    @team_type=TeamType.find(team_params["team_type_id"])

    @participant.attributes=participant_params
    if @person.save
      @person.dedup
      @team=Team.for_participant_form(@current_race,@person.county,@team_type)
      @participant.team_id=@team.id
      @participant.person_id=@person.id
      if @participant.save
        redirect_to [@current_race, @participant], notice:'Účastník byl úspěšně upraven.'
        return true
      end
    end
    render action: "edit"
  end
  def destroy
    @participant=Participant.find(params[:id])
    @participant.destroy
    redirect_to race_participants_url(@current_race)
  end
  private
  def participant_params
      params.require(:participant).permit(:category_id, :starting_no, :team_id, :person_id)
  end
  def previous_id
    params.permit(:previous_id)[:previous_id]
  end
  def handle_new_county(person,original_params)
    if person.county
      logger.info "Existing County chosen"
    else
      county_name=original_params[:county_id]
      logger.info("Creating new County #{county_name}")
      county=County.find_or_create_by(title:county_name)
      person.county=county
    end
  end
  def extract_person_params(person_params)
    person_params.permit(:county_id,:first_name,:last_name,:yob,:gender,:born)
  end
end
