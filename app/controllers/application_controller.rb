# encoding: UTF-8
require 'navigator'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_race
  before_filter :set_locale
  before_filter :set_navigator
  def set_locale
    if self.kind_of? RailsAdmin::ApplicationController
      I18n.locale = :en
    end
  end
  def set_current_race
    @current_race=Race.find(params[:race_id]) if params[:race_id]
  end
  def set_navigator
    @navigator=Navigator.new(params)
  end
  def group_sort_and_filter_class_for_current_race(klass)
    things=klass.for_race(@current_race)
    things=things.order("#{klass.sort_by(params[:group])} ASC") if params[:group]
    things=things.filter_by(params[:filter]) if params[:filter]
    things=things.where("people.last_name ILIKE ?",params[:search]+"%") if params[:search]
    if @navigator.reverse_sort
      things=things.order("#{klass.sort_by(@navigator.sort_by)} DESC")
    else
      things=things.order("#{klass.sort_by(@navigator.sort_by)} ASC")
    end
  end
end
