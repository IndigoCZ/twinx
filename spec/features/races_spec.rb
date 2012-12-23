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
    click_button "Vytvořit"
    page.should have_content("Závod byl úspěšně vytvořen.")
  end
  it "shows details of an existing race when I visit /:race_id" do
    race.save
    visit race_path(race.id)
    page.should have_content(race.title)
    page.should have_content(race.held_on)
  end
end
