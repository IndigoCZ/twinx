# encoding: UTF-8
require 'spec_helper'

describe "Results" do
  let(:race) { FactoryGirl.create(:race) }
  let(:county) { FactoryGirl.create(:county)}
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id, county_id:county.id)}
  let(:participant) { FactoryGirl.build(:participant, team_id:team.id, category_id:category.id) }
  let(:result) { FactoryGirl.build(:result, participant_id:participant.id) }
  before :each do
    category.save
    team.save
    participant.save
  end
  
  it "shows the new result form when I visit /new" do
    visit new_race_result_path(:race_id => race.id)
    page.should have_content("Nový výsledek")
  end

  it "creates a new position result when I fill in starting_no and position into the new result form" do
    visit new_race_result_path(:race_id => race.id)
    fill_in "Startovní č.", with:result.participant.starting_no
    fill_in "Pozice", with:result.position
    click_button "Vytvořit"
    page.should have_content("Výsledek byl úspěšně vytvořen.")
  end

  it "creates a new complete result when I fill in starting_no, time and position into the new result form" do
    visit new_race_result_path(:race_id => race.id)
    fill_in "Startovní č.", with:result.participant.starting_no
    fill_in "Pozice", with:result.position
    fill_in "result_time_min", with:2
    fill_in "result_time_sec", with:3
    fill_in "result_time_fract", with:45
    click_button "Vytvořit"
    page.should have_content("Výsledek byl úspěšně vytvořen.")
    page.should have_content("123450")
  end

  it "shows details of an existing result when I visit /:result_id" do
    result.save
    visit race_result_path(race.id, result.id)
    page.should have_content(result.participant.display_name)
  end

  it "updates a result when I fill in the edit result form" do
    result.save
    visit edit_race_result_path(race.id, result.id)
    fill_in "Pozice", with:1
    click_button "Uložit Výsledek"
    page.should have_content("Výsledek byl úspěšně upraven.")
  end

  it "shows a listing of results when visit the index" do
    result.save
    visit race_results_path(race.id)
    page.should have_content "Přehled Výsledeků"
    page.should have_content result.participant.display_name
  end

  it "deletes a result when I click the delete button", js:true do
    DatabaseCleaner.clean
    existing_result=FactoryGirl.create(:result)
    visit race_results_path(existing_result.participant.race.id)
    page.should have_content existing_result.participant.display_name
    page.should have_content "Smazat"
    expect{
      click_link 'Smazat'
      page.driver.accept_js_confirms!
    }.to change(Result,:count).by(-1)
    page.should have_content "Přehled Výsledeků"
    page.should_not have_content existing_result.participant.display_name
  end
end
