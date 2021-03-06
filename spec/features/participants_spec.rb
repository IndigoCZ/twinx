# encoding: UTF-8
require 'spec_helper'

def gender_to_human(gender)
  if gender=="male"
    "Muž"
  else
    "Žena"
  end
end

def fill_in_participant_county(participant_county_title)
  page.find("div#s2id_participant_person_county_id").find(".select2-arrow").click
  fill_in("Jednota",with:participant_county_title)
  page.find(".select2-input").native.send_keys(:return)
end

describe "Participants", :type => :feature do
  let(:race) { FactoryGirl.build(:race) }
  let(:county) { FactoryGirl.build(:county)}
  let(:team_type) { FactoryGirl.build(:team_type)}
  let(:second_team_type) { FactoryGirl.build(:team_type, title:"Some other prefix")}
  let(:category) { FactoryGirl.build(:category, race_id:race.id) }
  let(:second_category) { FactoryGirl.build(:category,title:"Some other category", race_id:race.id) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id, 
                                 county_id:county.id,
                                 team_type_id:team_type.id,
                                 title:"#{team_type.title} #{county.title}")}
  let(:person) { FactoryGirl.build(:person, county_id:county.id) }
  let(:participant) { FactoryGirl.build(:participant, team_id:team.id, category_id:category.id, person_id:person.id)}
  before :each do
    race.save
    county.save
    team_type.save
    person.save
    category.save
    team.save
  end

  it "shows the new participant form when I visit /new" do
    visit new_race_participant_path(:race_id => race.id)
    expect(page).to have_content("Nový účastník")
  end

  it "creates a new participant when I fill in the new participant form", js:true do
    expect {
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in_participant_county(county.title)

      select participant.category.title, from:"Kategorie"
      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")
    }.to change(Participant, :count).by(1)
  end

  it "shows details of a newly created participant when a participant is entered", js:true do
    visit new_race_participant_path(:race_id => race.id)
    fill_in "Startovní č.", with:participant.starting_no
    fill_in "Jméno", with:participant.person.first_name
    fill_in "Příjmení", with:participant.person.last_name
    fill_in "Rok nar.", with:participant.person.yob
    choose gender_to_human(participant.person.gender)

    fill_in_participant_county(county.title)

    select participant.category.title, from:"Kategorie"
    click_button "Vytvořit"
    expect(page).to have_content("Startovní číslo: #{participant.starting_no}")
    expect(page).to have_content("Jméno: #{participant.person.display_name}")
    expect(page).to have_content("Kategorie: #{participant.category.title}")
    expect(page).to have_content("Jednota: #{participant.team.title}")
  end

  it "fills in default starting number and county based on last entry", js:true do
    expect {
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in_participant_county(county.title)

      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")

      # Form-fill order reverted to let the category selection script work in the background
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name

      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")

    }.to change(Participant,:count).by(2)
    expect(Participant.last.starting_no).to eq(participant.starting_no+1)
    expect(Participant.last.person.county.title).to eq(county.title)
  end

  it "allows a persons birthday to be specified when entering a participant", js:true do
    DatabaseCleaner.clean
    this_race=FactoryGirl.create(:race)
    FactoryGirl.create(:team_type)
    this_category=FactoryGirl.create(:category,race:this_race)
    this_county=FactoryGirl.create(:county)
    this_person=FactoryGirl.build(:person,county:this_county)
    visit new_race_participant_path(:race_id => this_race.id)
    expect(page).to have_select('Narozen')
    fill_in "Startovní č.", with:1
    fill_in "Jméno", with:this_person.first_name
    fill_in "Příjmení", with:this_person.last_name
    fill_in "Rok nar.", with:this_person.yob
    select '13', from:"participant_person_born_3i"
    select 'duben', from:"participant_person_born_2i"
    choose gender_to_human(this_person.gender)

    fill_in_participant_county(this_county.title)

    select this_category.title, from:"Kategorie"
    click_button "Vytvořit"
    expect(page).to have_content("Účastník byl úspěšně vytvořen.")
  end

  it "creates only one new person when I sign a person into two categories", js:true do
    participant.save
    second_category.save
    expect{
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no+1000
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in_participant_county(county.title)

      select second_category.title, from:"Kategorie"
      click_button "Vytvořit Účastníka"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")
    }.to change(Person,:count).by(0)
  end
  it "automatically picks the appropriate category for the participant", js:true do
    DatabaseCleaner.clean
    this_race=FactoryGirl.create(:race)
    FactoryGirl.create(:team_type)
    old_male_category=FactoryGirl.create(:category, title:"OLD_MALE",race:this_race)
    FactoryGirl.create(:constraint, restrict:"min_age", value:"30", category:old_male_category)
    FactoryGirl.create(:constraint, restrict:"gender", value:"male", category:old_male_category)
    young_male_category=FactoryGirl.create(:category, title:"YOUNG_MALE",race:this_race)
    FactoryGirl.create(:constraint, restrict:"max_age", value:"29", category:young_male_category)
    FactoryGirl.create(:constraint, restrict:"gender", value:"male", category:young_male_category)
    old_female_category=FactoryGirl.create(:category, title:"OLD_FEMALE",race:this_race)
    FactoryGirl.create(:constraint, restrict:"min_age", value:"30", category:old_female_category)
    FactoryGirl.create(:constraint, restrict:"gender", value:"female", category:old_female_category)
    young_female_category=FactoryGirl.create(:category, title:"YOUNG_FEMALE",race:this_race)
    FactoryGirl.create(:constraint, restrict:"max_age", value:"29", category:young_female_category)
    FactoryGirl.create(:constraint, restrict:"gender", value:"female", category:young_female_category)

    visit new_race_participant_path(:race_id => this_race.id)
    fill_in "Rok nar.", with:Time.now.year-29
    choose gender_to_human("male")
    expect(page).to have_select('Kategorie', :selected => 'YOUNG_MALE')
    choose gender_to_human("female")
    expect(page).to have_select('Kategorie', :selected => 'YOUNG_FEMALE')
    fill_in "Rok nar.", with:Time.now.year-30
    choose gender_to_human("female") # Need to loose focus for capybara/firefox
    expect(page).to have_select('Kategorie', :selected => 'OLD_FEMALE')
    choose gender_to_human("male")
    expect(page).to have_select('Kategorie', :selected => 'OLD_MALE')
  end
  it "shows details of an existing participant when I visit /:participant_id" do
    participant.save
    visit race_participant_path(race.id, participant.id)
    expect(page).to have_content(participant.display_name)
    expect(page).to have_content(participant.team.title)
    expect(page).to have_content(participant.category.title)
  end

  it "updates a participant when I fill in the edit participant form" do
    participant.save
    visit edit_race_participant_path(race.id, participant.id)
    fill_in "Příjmení", with: "Novák"
    click_button "Uložit Účastníka"
    expect(page).to have_content("Účastník byl úspěšně upraven.")
  end

  it "creates a new county on create when I fill in a custom County name", js:true do
    expect {
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      # Get a county that definitely doesn't exist
      fill_in_participant_county(county.title+"Create County")

      select participant.category.title, from:"Kategorie"


      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")
    }.to change(County, :count).by(1)
    expect(Participant.last.person.county.title).to eq(county.title+"Create County")
  end

  it "creates a new county on update when I fill in a custom County name", js:true do
    participant.save
    expect {
      visit edit_race_participant_path(race.id, participant.id)

      # Get a county that definitely doesn't exist
      fill_in_participant_county(county.title+"Update County")

      click_button "Uložit Účastníka"
      expect(page).to have_content("Účastník byl úspěšně upraven.")
    }.to change(County, :count).by(1)
    participant.reload
    expect(participant.person.county.title).to eq(county.title+"Update County")
  end

  it "does not adjust an existing person if the participant details change", js:true do
    second_category.save
    expect {
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in_participant_county(county.title)

      select category.title, from:"Kategorie"

      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")

      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:(participant.person.yob-20)
      choose gender_to_human(participant.person.gender)
      select second_category.title, from:"Kategorie"

      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")

      visit edit_race_participant_path(race.id,Participant.last.id)
      fill_in "Jméno", with:participant.person.first_name+" Jr."
      click_button "Uložit"
      expect(page).to have_content("Účastník byl úspěšně upraven.")
    }.to change(Person, :count).by(2)
  end

  it "Handles empty people???"

  it "shows a listing of participants when I visit the index" do
    participant.save
    visit race_participants_path(race.id)
    expect(page).to have_content "Přehled Účastníků"
    expect(page).to have_content participant.person.first_name
  end
  xit "allows sorting of participants on the index" do
    z_person=FactoryGirl.create(:person,last_name:"ZZZZZ", county_id:county.id)
    FactoryGirl.create(:participant, team_id:team.id, category_id:category.id, person_id:z_person.id, starting_no:1)
    a_person=FactoryGirl.create(:person,last_name:"AAAAA", county_id:county.id)
    FactoryGirl.create(:participant, team_id:team.id, category_id:category.id, person_id:a_person.id, starting_no:2)

    visit race_participants_path(race.id)
    expect(page).to have_content(/ZZZZZ.*AAAAA/)
    expect(page.find("#name_sort")).to have_content "Jméno"
    page.find("#name_sort").click
    expect(page).to have_content(/AAAAA.*ZZZZZ/)
    expect(page.find("#name_sort")).to have_content "Jméno"
    page.find("#name_sort").click
    expect(page).to have_content(/ZZZZZ.*AAAAA/)
  end
  xit "allows filtering of participants on the index", js:true do
    DatabaseCleaner.clean
    this_race=FactoryGirl.create(:race)
    z_category=FactoryGirl.create(:category, title:"ZZZZZ",race:this_race)
    z_person=FactoryGirl.create(:person)
    FactoryGirl.create(:participant, category:z_category, person:z_person, starting_no:1)
    a_category=FactoryGirl.create(:category, title:"AAAAA",race:this_race)
    a_person=FactoryGirl.create(:person)
    FactoryGirl.create(:participant, category:a_category, person:a_person, starting_no:2)

    visit race_participants_path(this_race.id)
    expect(page).to have_content(/ZZZZZ.*AAAAA/)
    expect(page.find("#category_filter")).to have_content "Kategorie"
    page.find("#category_filter").find(".dropdown-toggle").click
    expect(page.find("#category_filter")).to have_content "AAAAA"
    within("#category_filter") { click_link "AAAAA" }
    expect(page).to have_content("AAAAA")
    expect(page).not_to have_content("ZZZZZ")
  end

  xit "allows searching for a participant by name"
  xit "allows searching for a participant by name while ignoring accented characters"

  it "deletes a participant when I click the delete button", js:true do
    DatabaseCleaner.clean
    existing_participant=FactoryGirl.create(:participant)
    visit race_participants_path(existing_participant.race.id)
    expect(page).to have_content existing_participant.person.first_name
    page.find("tbody").find(".dropdown-toggle").click
    expect(page).to have_content "Smazat"
    expect{
      click_link 'Smazat'
      accept_popup(page)
      expect(page).not_to have_content existing_participant.person.first_name
    }.to change(Participant,:count).by(-1)
    expect(page).to have_content "Přehled Účastníků"
  end

  it "pre-fills a team type in the form" do
    visit new_race_participant_path(:race_id => race.id)
    expect(page).to have_select("Druh Jednoty", :selected => team_type.title)
  end

  it "fills in previous team type based on last entry", js:true do
    second_team_type.save
    expect {
      visit new_race_participant_path(:race_id => race.id)
      fill_in "Startovní č.", with:participant.starting_no
      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in_participant_county(county.title)
      select second_team_type.title, from:"Druh Jednoty"

      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")

      # Form-fill order reverted to let the category selection script work in the background
      fill_in "Rok nar.", with:participant.person.yob
      choose gender_to_human(participant.person.gender)

      fill_in "Jméno", with:participant.person.first_name
      fill_in "Příjmení", with:participant.person.last_name

      click_button "Vytvořit"
      expect(page).to have_content("Účastník byl úspěšně vytvořen.")

    }.to change(Participant,:count).by(2)
    expect(Participant.last.team.team_type).to eq(second_team_type)
  end

  it "does not fail with an error when a new Person is invalid"
end
