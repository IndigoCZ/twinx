# encoding: UTF-8
require 'spec_helper'

describe "Participants" do
  let (:participant) { Participant.first }
  it "shows the new participant form when I visit /new" do
    visit new_race_participant_path(:race_id => Race.first.id)
    page.should have_content("Nový účastník")
  end
  it "creates a new participant when I fill in the new participant form" do
    visit new_race_participant_path(:race_id => Race.first.id)
    fill_in "Startovní číslo", with:"45679"
    fill_in "Jméno", with:"Matous"
    fill_in "Příjmení", with:"Drzka"
    fill_in "Rok nar.", with:"1950"
    fill_in "Pohlaví", with:"male"
    select "Moutnice", from:"Jednota"
    select "Juniori", from:"Kategorie"
    click_button "Vytvořit"
    page.should have_content("Účastník byl úspěšně vytvořen.")
  end
  it "shows details of an existing participant when I visit /:participant_id" do
    visit race_participant_path(participant.race.id, participant.id)
    page.should have_content(participant.display_name)
    page.should have_content(participant.team.county.title)
    page.should have_content(participant.category.title)
  end
end
