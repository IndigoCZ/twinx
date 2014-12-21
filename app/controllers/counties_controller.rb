class CountiesController < ApplicationController
  def index
    @counties=County.all
    respond_to do |format|
      format.json { render :json => @counties.map{|county|{id:county.id,text:county.title}} }
    end
  end
end
