require 'csv_interface'
# encoding: UTF-8
require 'csv'
class DataTransferController < ApplicationController
  def index
    @participants=@current_race.participants
    @header=["starting_no", "first_name", "last_name", "full_name", "gender", "yob", "team", "category", "position", "time", "born", "id_string"]
    respond_to do |format|
      format.html
      format.csv { send_data CSVInterface.export(@participants,@header) }
    end
  end
  def create
    CSVInterface.import(@current_race, params[:import].read.force_encoding("UTF-8"))
    redirect_to race_data_transfer_index_path(@current_race), notice: 'Import'
  end
end
