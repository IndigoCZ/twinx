# encoding: UTF-8
class RacesController < ApplicationController
  def index
    @races = Race.order(:held_on).reverse_order.all
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
    @race = Race.new(race_params)
    if @race.save
      redirect_to @race, notice: "Závod byl úspěšně vytvořen."
    else
      render action: "new"
    end
  end

  def update
    @race = Race.find(params[:id])
    if @race.update_attributes(race_params)
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
  private
  def race_params
    params.require(:race).permit(:held_on, :title, :subtitle, :short_name)
  end
end
