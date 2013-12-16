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
    @person=Person.new
    @person.gender="male"
    @person.yob="2000"
		@person.county_id=session[:last_county_id]
    @participant=Participant.new
		@participant.starting_no=session[:last_starting_no].to_i+1
  end
  def create
    @person=Person.new(params[:participant].delete(:person))
    @participant=Participant.new(participant_params)
    if @person.save
      @person.dedup
      @team=Team.with_race_and_title(@current_race,@person.county.title)
      @participant.team_id=@team.id
      @participant.person_id=@person.id
      session[:last_county_id]=@person.county.id
      if @participant.save
        session[:last_starting_no]=@participant.starting_no
        redirect_to new_race_participant_url(@current_race), notice:'Účastník byl úspěšně vytvořen.'
        return
      end
    end
    render action: "new"
  end
  def show
    @participant=Participant.find(params[:id])
  end
  def edit
    @participant=Participant.find(params[:id])
    @person=@participant.person
  end
  def update
    @participant=Participant.find(params[:id])
    @person=@participant.person
    @person.attributes=params[:participant].delete(:person)
    @team=Team.where(race_id:@current_race.id,county_id:@person.county.id).first_or_create
    @participant.team_id=@team.id
    @participant.attributes=participant_params
    if @person.save && @participant.save
      redirect_to [@current_race, @participant], notice:'Účastník byl úspěšně upraven.'
    else
      render action: "edit"
    end
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
end
