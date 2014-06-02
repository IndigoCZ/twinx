require 'spec_helper'

describe DataTransferController, :type => :feature do
  it "supports import of race results" do
    expect {
    @this_race=FactoryGirl.create(:race)
    visit race_data_transfer_index_path(race_id:@this_race)
    attach_file "import", "spec/fixtures/sample_for_import.csv"
    click_button "Import"
    }.to change(Person,:count).by(5)
  end
  it "supports export of race results" do
    this_race=FactoryGirl.create(:race)
    participant=FactoryGirl.create(:participant,race:this_race)
    visit race_data_transfer_index_path(race_id:this_race.id, format: "csv")
    expect(CSV.parse(page.body)).to eq [
      ["starting_no", "first_name", "last_name", "full_name", "gender", "yob", "team", "category", "position", "time", "born", "id_string"],
      [participant.starting_no.to_s, participant.person.first_name, participant.person.last_name, participant.person.full_name, participant.person.gender, participant.person.yob.to_s, participant.team.title, participant.category.code, "DNF",nil,participant.person.born,participant.person.id_string]
    ]
  end
end
