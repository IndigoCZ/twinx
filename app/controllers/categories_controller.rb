# encoding: UTF-8
class CategoriesController < ApplicationController
  def index
    @categories=@current_race.categories.includes(:constraints)
    @categories=@categories.for_gender(params[:gender]) if params[:gender]
    @categories=@categories.for_age(Time.now.year - params[:yob].to_i) if params[:yob]
    @categories=@categories.order("difficulty DESC")
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
      redirect_to [@current_race, @category], notice: 'Kategorie byla úspěšně upravena.'
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
