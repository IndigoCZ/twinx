# encoding: UTF-8
class ParticipantsController < ApplicationController
  def index
    @participants=@current_race.participants
  end
  def new
    @person=Person.new
    @participant=Participant.new
  end
  def create
    @person=Person.where(params[:person]).first_or_create
    @team=Team.where(race_id:@current_race.id,county_id:params[:person][:county_id]).first_or_create
    params[:participant][:team_id]=@team.id
    params[:participant][:person_id]=@person.id
    @participant=Participant.new(params[:participant])
    if @participant.save
      redirect_to race_participants_url(@current_race), notice:'Účastník byl úspěšně vytvořen.'
    else
      render action: "new"
    end
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
    @team=Team.where(race_id:@current_race.id,county_id:params[:person][:county_id]).first_or_create
    @participant.team_id=@team.id
    if @person.update_attributes(params[:person]) && @participant.update_attributes(params[:participant])
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

end
