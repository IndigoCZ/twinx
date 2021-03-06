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
    @people=@county.people
    first_name=params[:person_first_name]
    last_name=params[:person_last_name]
    @starting_no=params[:starting_no]
    if first_name
      @people=@people.where('first_name ILIKE ?',"%#{first_name}%")
    end
    if last_name
      @people=@people.where('last_name ILIKE ?',"%#{last_name}%")
    end
    @people=@people.order(:last_name, :first_name)
    respond_to do |format|
      format.html { render "people", layout: false }
      format.json { render :json => @people }
    end
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status: 404
  end
end
