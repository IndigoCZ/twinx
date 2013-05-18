require 'spec_helper'

describe DataTransferController do
  it "supports import of race results"
  it "supports export of race results" do
    this_race=FactoryGirl.create(:race)
    visit race_data_transfer_index_path(race_id:this_race.id, format: "csv")
    CSV.parse(page.body).should eq [["starting_no", "first_name", "last_name", "full_name", "gender", "yob", "team", "category", "position", "time", "born", "id_string"]]
  end
end
