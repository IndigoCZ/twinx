class TeamsController < ApplicationController
  def index
    @teams=@current_race.teams
  end
end
