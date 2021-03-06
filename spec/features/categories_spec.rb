# encoding: UTF-8
require 'spec_helper'

describe "Categories", :type => :feature do
  let(:race) { FactoryGirl.create(:race) }
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
  
  it "shows the new category form when I visit /new" do
    visit new_race_category_path(:race_id => race.id)
    expect(page).to have_content("Nová kategorie")
  end

  it "creates a new category when I fill in the new category form" do
    visit new_race_category_path(:race_id => race.id)
    fill_in "Název", with:category.title
    click_button "Vytvořit"
    expect(page).to have_content("Kategorie byla úspěšně vytvořena.")
  end

  it "shows details of an existing category when I visit /:category_id" do
    category.save
    visit race_category_path(race.id, category.id)
    expect(page).to have_content(category.title)
  end

  it "updates a category when I fill in the edit category form" do
    category.save
    visit edit_race_category_path(race.id, category.id)
    fill_in "Název", with: "Some other name"
    click_button "Uložit Kategorii"
    expect(page).to have_content("Kategorie byla úspěšně upravena.")
  end

  it "shows a listing of categories when visit the index" do
    category.save
    visit race_categories_path(race.id)
    expect(page).to have_content "Přehled Kategorií"
    expect(page).to have_content category.title
  end

  it "deletes a category when I click the delete button", js:true do
    DatabaseCleaner.clean
    category.save
    visit race_categories_path(race.id)
    expect(page).to have_content category.title
    page.find(".dropdown-toggle").click
    expect(page).to have_content "Smazat"
    expect{
      click_link 'Smazat'
      accept_popup(page)
      expect(page).not_to have_content category.title
    }.to change(Category,:count).by(-1)
    expect(page).to have_content "Přehled Kategorií"
  end

  it "allows me to specify age constraint when creating a category", js:true do
    visit new_race_category_path(:race_id => race.id)
    fill_in "Název", with:category.title
    click_link "Přidat"
    select "Věk do", from:"Typ"
    fill_in "Hodnota", with:"16"
    expect{
      click_button "Vytvořit"
    }.to change(Constraint,:count).by(1)
    expect(page).to have_content("Kategorie byla úspěšně vytvořena.")
  end

  it "allows me to specify gender constraint when creating a category", js:true do
    visit new_race_category_path(:race_id => race.id)
    fill_in "Název", with:category.title
    click_link "Přidat"
    select "Pohlaví", from:"Typ"
    fill_in "Hodnota", with:"male"
    expect{
      click_button "Vytvořit"
    }.to change(Constraint,:count).by(1)
    expect(page).to have_content("Kategorie byla úspěšně vytvořena.")
  end

  it "allows me to remove a constraint when editing"

end
