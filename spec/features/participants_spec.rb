# encoding: UTF-8
require 'spec_helper'

describe "Participants" do
  let(:race) { FactoryGirl.create(:race) }
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id)}
  let(:participant) { FactoryGirl.build(:participant, team_id:team.id, category_id:category.id) }
  before :each do
    category.save
    team.save
  end

  it "shows the new participant form when I visit /new" do
    visit new_race_participant_path(:race_id => race.id)
    page.should have_content("Nový účastník")
  end

  it "creates a new participant when I fill in the new participant form" do
    #save_and_open_page
    visit new_race_participant_path(:race_id => race.id)
    fill_in "Startovní číslo", with:participant.starting_no
    fill_in "Jméno", with:participant.person.first_name
    fill_in "Příjmení", with:participant.person.last_name
    fill_in "Rok nar.", with:participant.person.yob
    fill_in "Pohlaví", with:participant.person.gender
    select participant.team.county.title, from:"Jednota"
    select participant.category.title, from:"Kategorie"
    click_button "Vytvořit"
    page.should have_content("Účastník byl úspěšně vytvořen.")
  end
  it "shows details of an existing participant when I visit /:participant_id" do
    participant.save
    #=FactoryGirl.create(:participant, 
    visit race_participant_path(race.id, participant.id)
    page.should have_content(participant.display_name)
    page.should have_content(participant.team.county.title)
    page.should have_content(participant.category.title)
  end
end
