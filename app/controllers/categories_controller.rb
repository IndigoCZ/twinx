# encoding: UTF-8
require 'category_picker'
class CategoriesController < ApplicationController
  extend DefaultControllerActions
  default_update(Category)
  def index
    @categories=Category.for_race(@current_race).order("categories.sort_order ASC")
    if params[:gender] && params[:yob]
      @categories=CategoryPicker.new(@categories).pick(params)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @categories.map{|cat|{id:cat.id,title:cat.title}} }
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to [@current_race, @category], notice: 'Kategorie byla úspěšně vytvořena.'
    else
      render action: "new"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to race_categories_url @current_race
  end

  def results
    @category = Category.find(params[:id])
    @category_participants = @category.participants.includes(:person,:result).order(:starting_no)
    @previous_id=previous_id
    respond_to do |format|
      format.html { render "results", layout: false }
    end
  end
  private
  def category_params
    # There may be a problem with removal of individual constraints!
    params.require(:category).permit(:race_id, :title, :code, :sort_order, :difficulty, constraints_attributes: [:id, :restrict, :value, :_destroy])
  end
  def previous_id
      params.permit(:previous_id)[:previous_id]
  end
end
