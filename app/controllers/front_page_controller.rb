class FrontPageController < ApplicationController
  def index
    @races = Race.all
  end
end
