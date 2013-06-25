# encoding: UTF-8
require 'navigator'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_race
  #before_filter :set_locale
  before_filter :set_navigator
  #def set_locale
  #  if self.kind_of? RailsAdmin::ApplicationController
  #    I18n.locale = :en
  #  end
  #end
  def set_current_race
    @current_race=Race.find(params[:race_id]) if params[:race_id]
  end
  def set_navigator
    @navigator=Navigator.new(params)
  end
  def group_sort_and_filter_class_for_current_race(klass)
    @navigator.group_sort_and_filter(klass,klass.for_race(@current_race))
  end
end
