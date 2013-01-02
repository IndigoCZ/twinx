# encoding: UTF-8
require 'spec_helper'

def gender_to_human(gender)
  if gender=="male"
    "Muž"
  else
    "Žena"
  end
end

describe "Participants" do
  let(:race) { FactoryGirl.create(:race) }
  let(:county) { FactoryGirl.create(:county)}
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
  let(:second_category) { FactoryGirl.build(:category,title:"Some other category", race_id:race.id) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id, county_id:county.id)}
  let(:person) { FactoryGirl.build(:person, county_id:county.id) }
  let(:participant) { FactoryGirl.build(:participant, team_id:team.id, category_id:category.id, person_id:person.id)}
  before :each do
    person.save
    category.save
    second_category.save
    team.save
  end

  it "shows the new participant form when I visit /new" do
    visit new_race_participant_path(:race_id => race.id)
    page.should have_content("Nový účastník")
  end

  it "creates a new participant when I fill in the new participant form" do
    visit new_race_participant_path(:race_id => race.id)
    fill_in "Startovní č.", with:participant.starting_no
    fill_in "Jméno", with:participant.person.first_name
    fill_in "Příjmení", with:participant.person.last_name
    fill_in "Rok nar.", with:participant.person.yob
    choose gender_to_human(participant.person.gender)
    select county.title, from:"Jednota"
    select participant.category.title, from:"Kategorie"
    click_button "Vytvořit"
    page.should have_content("Účastník byl úspěšně vytvořen.")
  end
  it "creates only one new person when I sign a person into two categories" do
    participant.save
    expect{
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)
      select county.title, from:"Jednota"
      select second_category.title, from:"Kategorie"
      click_button "Vytvořit"
      page.should have_content("Účastník byl úspěšně vytvořen.")
    }.to change(Person,:count).by(0)
  end
  it "shows details of an existing participant when I visit /:participant_id" do
    participant.save
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
  it "allows sorting of participants on the index" do
    z_person=FactoryGirl.create(:person,last_name:"ZZZZZ", county_id:county.id)
    z_participant=FactoryGirl.create(:participant, team_id:team.id, category_id:category.id, person_id:z_person.id, starting_no:1)
    a_person=FactoryGirl.create(:person,last_name:"AAAAA", county_id:county.id)
    a_participant=FactoryGirl.create(:participant, team_id:team.id, category_id:category.id, person_id:a_person.id, starting_no:2)

    visit race_participants_path(race.id)
    page.should have_content(/ZZZZZ.*AAAAA/)
    page.find("#name_sort").should have_content "Jméno"
    page.find("#name_sort").click
    page.should have_content(/AAAAA.*ZZZZZ/)
  end
  it "allows filtering of participants on the index", js:true do
    DatabaseCleaner.clean
    this_race=FactoryGirl.create(:race)
    z_category=FactoryGirl.create(:category, title:"ZZZZZ",race:this_race)
    z_person=FactoryGirl.create(:person)
    z_participant=FactoryGirl.create(:participant, category:z_category, person:z_person, starting_no:1)
    a_category=FactoryGirl.create(:category, title:"AAAAA",race:this_race)
    a_person=FactoryGirl.create(:person)
    a_participant=FactoryGirl.create(:participant, category:a_category, person:a_person, starting_no:2)

    visit race_participants_path(this_race.id)
    page.should have_content(/ZZZZZ.*AAAAA/)
    page.find("#category_filter").should have_content "Kategorie"
    page.find("#category_filter").find(".dropdown-toggle").click
    page.find("#category_filter").should have_content "AAAAA"
    within("#category_filter") { click_link "AAAAA" }
    page.should have_content("AAAAA")
    page.should_not have_content("ZZZZZ")
  end

  it "deletes a participant when I click the delete button", js:true do
    DatabaseCleaner.clean
    existing_participant=FactoryGirl.create(:participant)
    visit race_participants_path(existing_participant.race.id)
    page.should have_content existing_participant.person.first_name
    page.find("tbody").find(".dropdown-toggle").click
    page.should have_content "Smazat"
    expect{
      click_link 'Smazat'
      page.driver.accept_js_confirms!
    }.to change(Participant,:count).by(-1)
    page.should have_content "Přehled Účastníků"
    page.should_not have_content existing_participant.person.first_name
  end

end
