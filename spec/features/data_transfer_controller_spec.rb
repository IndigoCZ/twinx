require 'spec_helper'

describe DataTransferController, :type => :feature do
  it "supports import of race results" do
    expect {
    @this_race=FactoryGirl.create(:race)
    visit race_admin_path(race_id:@this_race)
    attach_file "import", "spec/fixtures/sample_for_import.csv"
    click_button "Import"
    }.to change(Person,:count).by(5)
  end

  it "supports export of race results" do
    this_race=FactoryGirl.create(:race)
    ttype=FactoryGirl.create(:team_type)
    county=FactoryGirl.create(:county)
    team=FactoryGirl.create(:team,team_type:ttype,county:county)
    participant=FactoryGirl.create(:participant,race:this_race,team:team)
    visit race_admin_path(race_id:this_race.id, format: "csv")
    expect(CSV.parse(page.body)).to eq [
      ["starting_no", "first_name", "last_name", "gender", "yob", "ttype", "team", "category", "position", "time", "born"],
      [participant.starting_no.to_s, participant.person.first_name, participant.person.last_name, participant.person.gender, participant.person.yob.to_s, ttype.title, county.title, participant.category.code, "DNF",nil,participant.person.born]
    ]
  end

  it "allows category and team counters to be reset"
  it "shows the current app environment"
  it "lists possible links to the app"
end
