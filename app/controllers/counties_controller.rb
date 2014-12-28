class CountiesController < ApplicationController
  def index
    @counties=County.all
    respond_to do |format|
      format.json { render :json => @counties.map{ |county| { id:county.id,text:county.title } } }
    end
  end

  def people
    @county=County.find(params[:id])
    @current_race=Race.find(params[:race_id])
    respond_to do |format|
      format.html { render "people", layout: false }
      format.json { render :json => @county.people }
    end
  end
end
