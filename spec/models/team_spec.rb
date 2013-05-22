require 'spec_helper'

describe Team do
  context "Model basics" do
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

  context "scoring" do
    before(:each) do
      @team=FactoryGirl.create(:team)
    end
    it "provides an overall score for all participants"
    it "provides a total of the top N scores"
    it "provides a list of DNF participants" do
      a=FactoryGirl.create(:participant,team:@team)
      b=FactoryGirl.create(:participant,team:@team)
      FactoryGirl.create(:result,participant:a)
      @team.dnfs.should include b
      @team.dnfs.should_not include a
    end
  end
  context "lookups" do
    before(:each) do
      @race=FactoryGirl.create(:race)
      @county=FactoryGirl.create(:county)
    end
    it "finds a team for race and county if it exists" do
      @team=FactoryGirl.create(:team,race:@race,county:@county)
      Team.first_or_create_for_race_and_county(@race,@county).should eq @team
    end
    it "creates a team for race and county if it exists" do
      expect {
        Team.first_or_create_for_race_and_county(@race,@county)
      }.to change(Team,:count).by(1)
    end
  end
end
