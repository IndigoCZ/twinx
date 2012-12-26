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
    success=false
    Participant.transaction do
      @person=Person.where(params[:participant][:person]).first_or_create # Improve this
      @team=Team.where(race_id:@current_race.id,county_id:params[:participant][:person][:county_id]).first_or_create
      params[:participant][:team_id]=@team.id
      params[:participant][:person_id]=@person.id
      params[:participant].delete(:person)
      @participant=Participant.new(params[:participant])
      if @participant.save
        success=true
      else
        raise ActiveRecord::Rollback
      end
    end
    if success
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
    success=false
    Participant.transaction do
      @participant=Participant.find(params[:id])
      @person=@participant.person
      raise ActiveRecord::Rollback unless @person.update_attributes(params[:participant][:person])
      @team=Team.where(race_id:@current_race.id,county_id:@person.county.id).first_or_create
      params[:participant].delete(:person)
      @participant.team_id=@team.id
      if @participant.update_attributes(params[:participant])
        success=true
      else
        raise ActiveRecord::Rollback
      end
    end
    if success
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
