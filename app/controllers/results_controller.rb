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
    @previous_result=Result.find(prev_result_params[:previous_id]) if prev_result_params[:previous_id]
  end
  def create
    @result = Result.new(result_params)
    @result.race=@current_race
    if @result.save
      redirect_to new_race_result_url(@current_race,previous_id:@result.id), notice: 'Výsledek byl úspěšně vytvořen.'
    else
      if @result.participant_lookup(true)
        redirect_to [@current_race, @result.participant_lookup(true).result], alert: 'Výsledek pro účastníka již existuje.'
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
  def prev_result_params
    params.permit(:previous_id)
  end
end
