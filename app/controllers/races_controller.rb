# encoding: UTF-8
class RacesController < ApplicationController
  def initialize
    super
  end
  def index
    @races = Race.order(:held_on).reverse_order.to_a
  end

  def show
    @race = Race.find(params[:id])
  end

  def new
    @race = Race.new
    @last_race = Race.last
    @race.title=@last_race.title
    @race.subtitle=@last_race.subtitle
    @race.short_name=@last_race.short_name
    @race.held_on=Time.now.strftime("%Y-%m-%d")
    @rulesets = Dir.glob("config/rulesets/*.yml").map{|key| File.basename(key,".yml")}
  end

  def edit
    @race = Race.find(params[:id])
    @rulesets = ["Not applicable"]
  end

  def create
    @race = Race.new(race_params)
    if @race.save
      begin
        ruleset_file="config/rulesets/#{@race.ruleset}.yml"
        ruleset=YAML.load_file(ruleset_file)
        Category.set_ruleset_file(ruleset_file)
        ruleset["categories"].each_key do |code|
          Category.first_or_create_by_code(@race,code)
        end
        redirect_to @race, notice: "Závod byl úspěšně vytvořen a podařilo se automaticky vygenerovat kategorie."
      rescue
        redirect_to @race, notice: "Závod byl úspěšně vytvořen, ale nepodařilo se automaticky vygenerovat kategorie."
      end
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
    params.require(:race).permit(:held_on, :title, :subtitle, :short_name, :ruleset)
  end
end
