require 'csv_interface'
# encoding: UTF-8
require 'csv'
class DataTransferController < ApplicationController
  def index
    participants=@current_race.participants
    header=["starting_no", "first_name", "last_name", "full_name", "gender", "yob", "team", "category", "position", "time", "born", "id_string"]

    @app_links=`/sbin/ip addr show`.scan(/inet \d+.\d+.\d+.\d+/).map {|m| "http://#{m.split.last}:#{request.port}/"}
    respond_to do |format|
      format.html
      format.csv { send_data CSVInterface.export(participants,header) }
    end
  end
  def create
    if params[:import]
      CSVInterface.import(@current_race, params[:import].read.force_encoding("UTF-8"))
      redirect_to race_admin_path(@current_race), notice: 'Import successful'
    else
      redirect_to race_admin_path(@current_race), notice: 'Import failed'
    end
  end

  def fix
    return_string=""
    @current_race.categories.each do |cat|
      Category.reset_counters(cat.id, :participants)
      return_string+="C"
    end
    @current_race.teams.each do |team|
      Team.reset_counters(team.id, :participants)
      return_string+="T"
    end
    redirect_to race_admin_path(@current_race), notice: return_string
  end
end
