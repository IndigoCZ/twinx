class TeamsController < ApplicationController
  def index
    @teams=@current_race.teams.includes(:county).order("counties.title ASC")
  end
end
