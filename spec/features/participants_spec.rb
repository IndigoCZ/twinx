# encoding: UTF-8
require 'spec_helper'

describe "Participants" do
  let(:race) { FactoryGirl.create(:race) }
  let(:county) { FactoryGirl.create(:county)}
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id, county_id:county.id)}
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
    fill_in "Startovní č.", with:participant.starting_no
    fill_in "Jméno", with:participant.person.first_name
    fill_in "Příjmení", with:participant.person.last_name
    fill_in "Rok nar.", with:participant.person.yob
    fill_in "Pohlaví", with:participant.person.gender
    select county.title, from:"Jednota"
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

  it "updates a participant when I fill in the edit participant form" do
    participant.save
    visit edit_race_participant_path(race.id, participant.id)
    fill_in "Příjmení", with: "Novák"
    click_button "Uložit Účastníka"
    page.should have_content("Účastník byl úspěšně upraven.")
  end

  it "shows a listing of participants when I visit the index" do
    participant.save
    visit race_participants_path(race.id)
    page.should have_content "Přehled Účastníků"
    page.should have_content participant.person.first_name
  end

  it "deletes a participant when I click the delete button", js:true do
    DatabaseCleaner.clean
    existing_participant=FactoryGirl.create(:participant)
    visit race_participants_path(existing_participant.race.id)
    page.should have_content existing_participant.person.first_name
    page.should have_content "Smazat"
    expect{
      click_link 'Smazat'
      page.driver.accept_js_confirms!
    }.to change(Participant,:count).by(-1)
    page.should have_content "Přehled Účastníků"
    page.should_not have_content existing_participant.person.first_name
  end

end
