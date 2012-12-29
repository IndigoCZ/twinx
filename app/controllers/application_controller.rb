class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_current_race
  def get_current_race
    if params[:race_id]
      @current_race=Race.find(params[:race_id])
    #else
    #  @current_race=NullRace.new
    end
  end
end
