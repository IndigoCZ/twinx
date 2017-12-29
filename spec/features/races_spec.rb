# encoding: UTF-8
require 'spec_helper'

describe "Races", :type => :feature do
  let(:race) { FactoryGirl.build(:race) }

  before(:each) do
    FactoryGirl.create(:race,title:"first race title")
    FactoryGirl.create(:race,title:"second race title")
    FactoryGirl.create(:race,title:"third race title")
  end

  it "shows a list of races when I visit index or root url" do
    visit root_url
    expect(page).to have_content("Přehled Závodů")
    visit races_path
    expect(page).to have_content("Přehled Závodů")
    expect(page).to have_content("first race title")
  end
  # Replace with a test that ensures these links work!
  it "shows important links for each race" do
    visit root_url
    hero=find("#hero_race")
    expect(hero).to have_link("Účastníci")
    expect(hero).to have_link("Výsledky")
    expect(hero).to have_link("Kategorie")
    expect(hero).to have_link("Jednoty")
    expect(hero).to have_link("Upravit")
    thumb=first("div.thumbnail")
    expect(thumb).to have_link("Účastníci")
    expect(thumb).to have_link("Výsledky")
    expect(thumb).to have_link("Kategorie")
    expect(thumb).to have_link("Jednoty")
    expect(thumb).to have_link("Upravit")
  end

  it "shows the new race form when I visit /new" do
    visit new_race_path
    expect(page).to have_content("Nový závod")
  end

  it "creates a new race when I fill in the new race form" do
    visit new_race_path
    fill_in "Název", with:race.title

    fill_in "Datum", with:race.held_on
    click_button "Vytvořit Závod"
    expect(page).to have_content("Závod byl úspěšně vytvořen")
  end

  # Not accessible, perhaps it should be removed
  it "shows details of an existing race when I visit /:race_id" do
    race.save
    visit race_path(race.id)
    expect(page).to have_content(race.title)
    expect(page).to have_content(race.held_on)
  end

  it "shows the edit race form when I visit /edit" do
    race.save
    visit edit_race_path(race.id)
    expect(page).to have_content("Upravit závod")
  end

  it "updates a race when I fill in the edit race form" do
    race.save
    visit edit_race_path(race.id)
    fill_in "Název", with: "Some other name"

    fill_in "Datum", with: race.held_on+1.day
    click_button "Uložit Závod"
    expect(page).to have_content("Závod byl úspěšně upraven.")
  end

  it "deletes a race when I click the delete button", js:true do
    DatabaseCleaner.clean
    race.save
    visit races_path # Causes QFont::setPixelSize: Pixel size <= 0 (0)
    expect(page).to have_content race.title
    expect(page).to have_content "Smazat"
    expect{
      #within "#race_#{existing_race.id}" do
        click_link 'Smazat'
      #end
      accept_popup(page)
      expect(page).not_to have_content race.title
    }.to change(Race,:count).by(-1)
    expect(page).to have_content "Přehled Závodů"
  end
end
