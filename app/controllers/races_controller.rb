# encoding: UTF-8
class RacesController < ApplicationController
  def index
    @races = Race.all
  end

  def show
    @race = Race.find(params[:id])
  end

  def new
    @race = Race.new
  end

  def edit
    @race = Race.find(params[:id])
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      redirect_to @race, notice: "Závod byl úspěšně vytvořen."
    else
      render action: "new"
    end
  end

  def update
    @race = Race.find(params[:id])
    if @race.update_attributes(params[:race])
      redirect_to @race, notice: "Závod byl úspěšně upraven."
    else
      render action: "edit"
    end
  end

  def destroy
    @race = Race.find(params[:id])
    @race.destroy
    redirect_to races_url
  end
end
