class TeamsController < ApplicationController
  def index
    if params[:sort]=="points"
      @teams=@current_race.teams.sort_by{ |t| t.points(params[:limit]) }.reverse
    else
      @teams=@current_race.teams.includes(:county).order("counties.title ASC").references(:county)
    end
    respond_to do |format|
      format.html
      format.pdf
    end
  end
end
