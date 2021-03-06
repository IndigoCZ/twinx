# encoding: UTF-8
class ResultsController < ApplicationController
  extend DefaultControllerActions
  default_update(Result)
  def index
    @results=group_sort_and_filter_class_for_current_race(Result)
    respond_to do |format|
      format.html
      format.pdf
    end
  end
  def new
    @result = Result.new
    @previous_result=Result.find(previous_id) if previous_id
    @result.starting_no=params[:prefill_starting_no]
    @result.position=@previous_result.position+1 if @previous_result
  end
  def create
    @result = Result.new(result_params)
    @result.race=@current_race
    if @result.save
      redirect_to new_race_result_url(@current_race,previous_id:@result.id), notice: 'Výsledek byl úspěšně vytvořen.'
    else
      lookup=@result.participant_lookup(true)
      if lookup && lookup.result
        redirect_to [@current_race, lookup.result], alert: 'Výsledek pro účastníka již existuje.'
      else
        render action: "new"
      end
    end
  end
  def show
    @result = Result.find(params[:id])
  end
  def edit
    @result = Result.find(params[:id])
    @disable_starting_no = true
  end
  def destroy
    @result = Result.find(params[:id])
    @result.destroy
    redirect_to race_results_url(@current_race)
  end
  private
  def result_params
    params.require(:result).permit(:position, :participant_id, :starting_no, time:[:min,:sec,:fract])
  end
  def previous_id
    params.permit(:previous_id)[:previous_id]
  end
end
