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
  end
  def create
    @result = Result.new(result_params)
    @result.race=@current_race
    if @result.save
      redirect_to new_race_result_url(@current_race), notice: 'Výsledek byl úspěšně vytvořen.'
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
    params.require(:result).permit(:position, :time, :participant_id, :starting_no)
  end
end
