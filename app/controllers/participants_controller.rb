# encoding: UTF-8
class ParticipantsController < ApplicationController
  def index
    @participants=Participant.for_race(@current_race)
    @participants=@participants.order("#{Participant.sort_by(params[:group])} ASC") if params[:group]
    if params[:sort]
      @participants=@participants.order("#{Participant.sort_by(params[:sort])} ASC")
    elsif params[:rsort]
      @participants=@participants.order("#{Participant.sort_by(params[:rsort])} DESC")
    else
      @participants=@participants.order("#{Participant.sort_by} ASC")
    end
    @participants=@participants.filter_by(params[:filter]) if params[:filter]
    if params[:search] && params[:search].length > 0
      @participants=@participants.where("people.last_name ILIKE ?",params[:search]+"%")
    end
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
    if @person.valid?
      if @person.save && @person.dedup
        @team=Team.where(race_id:@current_race.id,county_id:@person.county.id).first_or_create
        @participant=Participant.new(params[:participant])
        @participant.team_id=@team.id
        @participant.person_id=@person.id
        session[:last_county_id]=@person.county.id
        if @participant.save
          session[:last_starting_no]=@participant.starting_no
          redirect_to new_race_participant_url(@current_race), notice:'Účastník byl úspěšně vytvořen.'
          return
        end
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
    @participant.attributes=params[:participant]
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

end
