# encoding: UTF-8
class ResultsController < ApplicationController
  def index
    @results = @current_race.results
    @results=Result.for_race(@current_race)
    if params[:sort]
      @results=@results.order("#{Result.sort_by(params[:sort])} ASC")
    elsif params[:rsort]
      @results=@results.order("#{Result.sort_by(params[:rsort])} DESC")
    else
      @results=@results.order("#{Result.sort_by} ASC")
    end
    @results=@results.filter_by(params[:filter]) if params[:filter]
    if params[:search] && params[:search].length > 0
      @results=@results.where("people.last_name LIKE ?",params[:search]+"%")
    end
  end
  def new
    @result = Result.new
    @participant=Participant.new
  end
  def create
    starting_no=params[:result][:participant][:starting_no]
    params[:result].delete(:participant)
    @result = Result.new(params[:result])
    @participant=Participant.find_by_starting_no(starting_no)
    @result.participant=@participant
    if @result.save
      redirect_to [@current_race, @result], notice: 'Výsledek byl úspěšně vytvořen.'
    else
      @participant||=Participant.new(starting_no:starting_no)
      render action: "new"
    end
  end
  def show
    @result = Result.find(params[:id])
    @participant=@result.participant
  end
  def edit
    @result = Result.find(params[:id])
    @participant=@result.participant
    @result = Result.find(params[:id])
    @result.participant=@participant
  end
  def update
    starting_no=params[:result][:participant][:starting_no]
    params[:result].delete(:participant)
    @result = Result.find(params[:id])
    @participant=Participant.find_by_starting_no(starting_no)
    params[:result][:participant_id]=@participant.id
    if @result.update_attributes(params[:result])
      redirect_to [@current_race,@result], notice: 'Výsledek byl úspěšně upraven.'
    else
      @participant||=Participant.new(starting_no:starting_no)
      render action: "edit"
    end
  end
  def destroy
    @result = Result.find(params[:id])
    @result.destroy
    redirect_to race_results_url(@current_race)
  end
end
