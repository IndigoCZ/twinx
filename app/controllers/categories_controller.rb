# encoding: UTF-8
class CategoriesController < ApplicationController
  def index
    @categories=@current_race.categories
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
    @category = Category.new(params[:category])
    if @category.save
      redirect_to [@current_race, @category], notice: 'Kategorie byla úspěšně vytvořena.'
    else
      render action: "new"
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to [@current_race, @category], notice: 'Kategorie byla úspěšně vytvořena.'
    else
      render action: "edit"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to race_categories_url @current_race
  end
end
