# encoding: UTF-8
require 'spec_helper'

describe "Categories" do
  let(:race) { FactoryGirl.create(:race) }
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
=begin
  let(:team) { FactoryGirl.build(:team, race_id:race.id)}
  let(:participant) { FactoryGirl.build(:participant, team_id:team.id, category_id:category.id) }
  before :each do
    category.save
    team.save
  end
=end
  it "shows the new category form when I visit /new" do
    visit new_race_category_path(:race_id => race.id)
    page.should have_content("Nová kategorie")
  end

  it "creates a new category when I fill in the new category form" do
    visit new_race_category_path(:race_id => race.id)
    fill_in "Název", with:category.title
    click_button "Vytvořit"
    page.should have_content("Kategorie byla úspěšně vytvořena.")
  end

  it "shows details of an existing category when I visit /:category_id" do
    category.save
    visit race_category_path(race.id, category.id)
    page.should have_content(category.title)
  end
end
