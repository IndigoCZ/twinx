# encoding: UTF-8
require 'category_picker'
class CategoriesController < ApplicationController
  extend DefaultControllerActions
  default_update(Category)
  def index
    @categories=Category.for_race(@current_race)
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
  private
  def category_params
    params.require(:category).permit(:race_id, :title, :constraints_attributes, :code, :sort_order, :difficulty)
  end
end
