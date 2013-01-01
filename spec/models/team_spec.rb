require 'spec_helper'

describe Team do
  it "has a valid factory" do
    FactoryGirl.build(:team).should be_valid
  end
  it "is invalid without a race" do
    FactoryGirl.build(:team, race_id:nil).should_not be_valid
  end
  it "is invalid without a county" do
    FactoryGirl.build(:team, county_id:nil).should_not be_valid
  end
  it "provides a quick link to it's county title" do
    team=FactoryGirl.create(:team)
    team.title.should be == team.county.title
  end
  it "provides a scope for current race" do
    race=FactoryGirl.create(:race)
    team=FactoryGirl.create(:team,race:race)
    race.teams.should be == Team.for_race(race)
  end
end
