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
    cleanup_stats={
      removed_people:0,
      removed_teams:0,
      removed_counties:0
    }
    Person.includes(:participants).select{|p| p.participants.size == 0}.each do |p|
      p.delete
      cleanup_stats[:removed_people]+=1
    end
    Team.where(participants_count:0).each do |x|
      x.delete
      cleanup_stats[:removed_teams]+=1
    end
    County.includes(:teams).select{|c| c.teams.size == 0}.each do |c|
      c.delete
      cleanup_stats[:removed_counties]+=1
    end
    @current_race.categories.each do |cat|
      Category.reset_counters(cat.id, :participants)
    end
    @current_race.teams.each do |team|
      Team.reset_counters(team.id, :participants)
    end
    redirect_to race_admin_path(@current_race), notice: cleanup_stats.inspect
  end

  def shutdown
    `sudo shutdown -h now`
  end
end
