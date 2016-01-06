class CountiesController < ApplicationController
  def index
    @counties=County.all
    respond_to do |format|
      format.json { render :json => @counties.order(:title).map{ |county| { id:county.id,text:county.title } } }
    end
  end

  def people
    @county=County.find(params[:id])
    @current_race=Race.find(params[:race_id])
    respond_to do |format|
      format.html { render "people", layout: false }
      format.json { render :json => @county.people.order(:last_name, :first_name) }
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status: 404
  end
end
