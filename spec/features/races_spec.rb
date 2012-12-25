# encoding: UTF-8
require 'spec_helper'

describe "Races" do
  let(:race) { FactoryGirl.build(:race) }

  it "shows the new race form when I visit /new" do
    visit new_race_path
    page.should have_content("Nový závod")
  end

  it "creates a new race when I fill in the new race form" do
    visit new_race_path
    fill_in "Název", with:race.title

    fill_in "Datum", with:race.held_on
    click_button "Vytvořit Závod"
    page.should have_content("Závod byl úspěšně vytvořen.")
  end

  it "shows details of an existing race when I visit /:race_id" do
    race.save
    visit race_path(race.id)
    page.should have_content(race.title)
    page.should have_content(race.held_on)
  end

  it "shows the edit race form when I visit /edit" do
    race.save
    visit edit_race_path(race.id)
    page.should have_content("Upravit závod")
  end

  it "updates a race when I fill in the edit race form" do
    race.save
    visit edit_race_path(race.id)
    fill_in "Název", with: "Some other name"

    fill_in "Datum", with: race.held_on+1.day
    click_button "Uložit Závod"
    page.should have_content("Závod byl úspěšně upraven.")
  end

  it "shows a listing of races when visit the index" do
    race.save
    visit races_path
    page.should have_content "Přehled Závodů"
    page.should have_content race.title
  end

  it "deletes a race when I click the delete button", js:true do
    DatabaseCleaner.clean
    race.save
    visit races_path
    page.should have_content race.title
    page.should have_content "Smazat"
    expect{
      #within "#race_#{existing_race.id}" do
        click_link 'Smazat'
      #end
      page.driver.accept_js_confirms!
    }.to change(Race,:count).by(-1)
    page.should have_content "Přehled Závodů"
    page.should_not have_content race.title
  end
end
