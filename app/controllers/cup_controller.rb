class CupController < ApplicationController
  def index
    @point_limit=params[:limit]||10
    @teams=@current_race.teams.includes(:team_type).where(team_type:TeamType.first).sort_by{ |t| t.points(@point_limit) }.reverse
    respond_to do |format|
      format.html
      format.pdf
    end
  end
end
