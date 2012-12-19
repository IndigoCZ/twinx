require 'spec_helper'

describe "Participants" do
  it "creates a new participant when I fill in the new participant form" do
    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    get new_race_participant_path( :race_id => Race.first.id)
    response.status.should be(200)
    # Incomplete
  end
end
