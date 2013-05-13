require 'csv_interface'
# encoding: UTF-8
require 'csv'
class DataTransferController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.csv { send_data CSVInterface.export(@current_race) }
    end
  end
  def create
    CSVInterface.import(params[:import].read)
    redirect_to race_data_transfer_index_path(@current_race), notice: 'Import'
  end
end
