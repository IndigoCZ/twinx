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

  def new
    @team = Team.new
  end

  def create
    @team = County.new(team_params)
    if @team.save
      redirect_to race_teams_path(@current_race), notice: 'Jednota byla úspěšně vytvořena.'
    else
      render action: "new"
    end
  end

  private
  def team_params
    params.require(:team).permit(:title)
  end
end
