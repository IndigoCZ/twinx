# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_current_race
  before_filter :set_locale
  def set_locale
    if self.kind_of? RailsAdmin::ApplicationController
      I18n.locale = :en
    end
  end
  def get_current_race
    if params[:race_id]
      @current_race=Race.find(params[:race_id])
    #else
    #  @current_race=NullRace.new
    end
  end

  def group_sort_and_filter_class_for_current_race(klass)
    things=klass.for_race(@current_race)
    things=things.order("#{klass.sort_by(params[:group])} ASC") if params[:group]
    if params[:sort]
      things=things.order("#{klass.sort_by(params[:sort])} ASC")
    elsif params[:rsort]
      things=things.order("#{klass.sort_by(params[:rsort])} DESC")
    else
      things=things.order("#{klass.sort_by} ASC")
    end
    things=things.filter_by(params[:filter]) if params[:filter]
    if params[:search] && params[:search].length > 0
      things=things.where("people.last_name ILIKE ?",params[:search]+"%")
    end
    return things
  end

  def default_update(klass)
    @item = klass.find(params[:id])
    klass_sym=klass.to_s.downcase.to_sym
    if @item.update_attributes(params[klass_sym])
      redirect_to [@current_race, @item], notice: t("messages.#{klass_sym}.updated_successfully")
    else
      render action: "edit"
    end
  end
end
