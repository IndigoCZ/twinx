# encoding: UTF-8
require 'spec_helper'

describe "Results", :type => :feature do
  context "Basic model" do
    before :each do
      DatabaseCleaner.clean
      @race=FactoryGirl.create(:race)
      @county=FactoryGirl.create(:county)
      @category=FactoryGirl.create(:category, race_id:@race.id)
      @team=FactoryGirl.create(:team, race_id:@race.id, county_id:@county.id)
      @person=FactoryGirl.create(:person, county_id:@county.id)
      @participant=FactoryGirl.create(:participant, person_id:@person.id, team_id:@team.id, category_id:@category.id)
      #@result=FactoryGirl.build(:result, participant_id:participant.id)
    end

    it "shows the new result form when I visit /new" do
      visit new_race_result_path(:race_id => @race.id)
      expect(page).to have_content("Nový výsledek")
    end

    it "creates a new position result when I fill in starting_no and position into the new result form" do
      visit new_race_result_path(:race_id => @race.id)
      fill_in "Startovní č.", with:@participant.starting_no
      fill_in "Pozice", with:113
      click_button "Vytvořit"
      expect(page).to have_content("Výsledek byl úspěšně vytvořen.")
    end

    it "creates a new complete result when I fill in starting_no, time and position into the new result form" do
      expect{
        visit new_race_result_path(:race_id => @race.id)
        fill_in "Startovní č.", with:@participant.starting_no
        fill_in "Pozice", with:112
        fill_in "result_time_min", with:2
        fill_in "result_time_sec", with:3
        fill_in "result_time_fract", with:45
        click_button "Vytvořit"
        expect(page).to have_content("Výsledek byl úspěšně vytvořen.")
      }.to change(Result,:count).by(1)
      expect(@participant.result.time.to_i).to eq 123450
    end

    it "shows details of a newly created result when a result is entered" do
      visit new_race_result_path(:race_id => @race.id)
      fill_in "Startovní č.", with:@participant.starting_no
      fill_in "Pozice", with:112
      fill_in "result_time_min", with:2
      fill_in "result_time_sec", with:3
      fill_in "result_time_fract", with:45
      click_button "Vytvořit"
      expect(page).to have_content("Pozice: 112")
      expect(page).to have_content("Kategorie: #{@participant.category.title}")
      expect(page).to have_content("Startovní číslo: #{@participant.starting_no}")
      expect(page).to have_content("Účastník: #{@participant.person.display_name}")
      expect(page).to have_content("Čas: 2:03.450")
    end

    it "shows details of an existing result when I visit /:result_id" do
      result=FactoryGirl.create(:result, participant_id:@participant.id)
      visit race_result_path(@race.id, result.id)
      expect(page).to have_content(result.participant.display_name)
    end

    it "updates a result when I fill in the edit result form" do
      result=FactoryGirl.create(:result, participant_id:@participant.id)
      visit edit_race_result_path(@race.id, result.id)
      fill_in "Pozice", with:1
      click_button "Uložit Výsledek"
      expect(page).to have_content("Výsledek byl úspěšně upraven.")
    end

    it "shows a listing of results when I visit the index" do
      result=FactoryGirl.create(:result, participant_id:@participant.id)
      visit race_results_path(@race.id)
      expect(page).to have_content "Přehled Výsledků"
      expect(page).to have_content result.participant.display_name
    end

    xit "allows sorting of results on the index" do
      z_person=FactoryGirl.create(:person,last_name:"ZZZZZ", county_id:@county.id)
      z_participant=FactoryGirl.create(:participant, team_id:@team.id, category_id:@category.id, person_id:z_person.id, starting_no:123)
      z_result=FactoryGirl.create(:result, position:1, participant:z_participant)
      a_person=FactoryGirl.create(:person,last_name:"AAAAA", county_id:@county.id)
      a_participant=FactoryGirl.create(:participant, team_id:@team.id, category_id:@category.id, person_id:a_person.id, starting_no:456)
      a_result=FactoryGirl.create(:result, position:2, participant:a_participant)

      visit race_results_path(@race.id)
      expect(page).to have_content(/ZZZZZ.*AAAAA/)
      expect(page.find("#name_sort")).to have_content "Jméno"
      page.find("#name_sort").click
      expect(page).to have_content(/AAAAA.*ZZZZZ/)
    end
    xit "allows filtering of results on the index", js:true do
      DatabaseCleaner.clean
      this_race=FactoryGirl.create(:race)
      z_category=FactoryGirl.create(:category, title:"ZZZZZ",race:this_race)
      z_person=FactoryGirl.create(:person)
      z_participant=FactoryGirl.create(:participant, category:z_category, person:z_person, starting_no:1)
      z_result=FactoryGirl.create(:result, position:1, participant:z_participant)
      a_category=FactoryGirl.create(:category, title:"AAAAA",race:this_race)
      a_person=FactoryGirl.create(:person)
      a_participant=FactoryGirl.create(:participant, category:a_category, person:a_person, starting_no:2)
      a_result=FactoryGirl.create(:result, position:1, participant:a_participant)

      visit race_results_path(this_race.id)
      expect(page).to have_content(/ZZZZZ.*AAAAA/)
      expect(page.find("#category_filter")).to have_content "Kategorie"
      page.find("#category_filter").find(".dropdown-toggle").click
      expect(page.find("#category_filter")).to have_content "AAAAA"
      within("#category_filter") { click_link "AAAAA" }
      expect(page).to have_content("AAAAA")
      expect(page).not_to have_content("ZZZZZ")
    end

    it "deletes a result when I click the delete button", js:true do
      DatabaseCleaner.clean
      existing_result=FactoryGirl.create(:result)
      visit race_results_path(existing_result.participant.race.id)
      expect(page).to have_content existing_result.participant.display_name
      page.find("tbody").find(".dropdown-toggle").click
      expect(page).to have_content "Smazat"
      expect{
        click_link 'Smazat'
        accept_popup(page)
        expect(page).not_to have_content existing_result.participant.display_name
      }.to change(Result,:count).by(-1)
      expect(page).to have_content "Přehled Výsledků"
    end
  end

  context "PDF" do
    it "supports PDF view of race results" do
      this_race=FactoryGirl.create(:race,subtitle:"Subtitle")
      participant=FactoryGirl.create(:participant,race:this_race)
      result=FactoryGirl.create(:result,participant:participant,time_msec:10000)
      expect {
        visit race_results_path(race_id:this_race.id, format: "pdf")
      }.not_to raise_error
    end
  end

  context "Complex interactions" do
    it "redirects me to an existing result when I try to create a duplicate result" do
      DatabaseCleaner.clean
      existing_race=FactoryGirl.create(:race)
      existing_county=FactoryGirl.create(:county)
      existing_category=FactoryGirl.create(:category, race_id:existing_race.id)
      existing_team=FactoryGirl.create(:team, race_id:existing_race.id, county_id:existing_county.id)
      existing_person=FactoryGirl.create(:person, county:existing_county)
      existing_participant=FactoryGirl.create(:participant, person:existing_person, team:existing_team, category:existing_category)
      existing_result=FactoryGirl.create(:result,participant:existing_participant)
      visit new_race_result_path(:race_id => existing_race.id)
      fill_in "Startovní č.", with:existing_participant.starting_no
      fill_in "Pozice", with:111
      click_button "Vytvořit"
      expect(URI.parse(current_url).path).to eq(race_result_path(existing_race.id,existing_result.id))
      expect(page).to have_content("Výsledek pro účastníka již existuje.")
    end
    it "allows me to create a result even when there is a duplicate starting no in another race" do
      DatabaseCleaner.clean
      race1=FactoryGirl.create(:race)
      race2=FactoryGirl.create(:race)
      existing_county=FactoryGirl.create(:county)
      cat1=FactoryGirl.create(:category, race_id:race1.id)
      cat2=FactoryGirl.create(:category, race_id:race2.id)
      team1=FactoryGirl.create(:team, race_id:race1.id, county_id:existing_county.id)
      team2=FactoryGirl.create(:team, race_id:race2.id, county_id:existing_county.id)
      existing_person=FactoryGirl.create(:person, county:existing_county)
      runner1=FactoryGirl.create(:participant, person:existing_person, team:team1, category:cat1, starting_no:123)
      runner2=FactoryGirl.create(:participant, person:existing_person, team:team2, category:cat2, starting_no:123)
      visit new_race_result_path(:race_id => race2.id)
      fill_in "Startovní č.", with:123
      fill_in "Pozice", with:111
      click_button "Vytvořit"
      expect(page).to have_content("Výsledek byl úspěšně vytvořen.")
      expect(runner1.result).to be_nil
      expect(runner2.result.position).to eq 111
    end
  end
end
