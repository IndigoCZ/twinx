require 'spec_helper'

describe Team, :type => :model do
  context "Model basics" do
    it "has a valid factory" do
      expect(FactoryGirl.build(:team)).to be_valid
    end
    it "is invalid without a race" do
      expect(FactoryGirl.build(:team, race_id:nil)).not_to be_valid
    end
    it "provides a scope for current race" do
      race=FactoryGirl.create(:race)
      team=FactoryGirl.create(:team,race:race)
      expect(race.teams).to eq(Team.for_race(race))
    end
    it "can be deleted when empty" do
      @team=FactoryGirl.create(:team)
      expect {
        @team.destroy
      }.to change(Team,:count).by(-1)
    end
    it "cannot be deleted while it has participants" do
      @team=FactoryGirl.create(:team)
      FactoryGirl.create(:participant,team:@team)
      expect {
        @team.destroy
      }.not_to change(Team,:count)
    end
    it "provides a list of DNF participants" do
      @team=FactoryGirl.create(:team)
      a=FactoryGirl.create(:participant,team:@team)
      b=FactoryGirl.create(:participant,team:@team)
      FactoryGirl.create(:result,participant:a)
      expect(@team.dnfs).to include b
      expect(@team.dnfs).not_to include a
    end
  end
  context "scoring" do
    before(:each) do
      @team=FactoryGirl.create(:team)
      1.upto(15) do |i|
        participant=FactoryGirl.create(:participant,team:@team)
        Result.create(participant_id:participant.id,position:i)
      end
    end
    it "provides an overall score for all participants" do
      expect(@team.points).to eq 71 # 12 10 9 8 7 6 5 4 3 2 1 1 1 1 1
    end
    it "provides a total of the top N scores" do
      expect(@team.points(1)).to eq 12 # 12
      expect(@team.points(3)).to eq 31 # 12 10 9
      expect(@team.points(9)).to eq 64 # 12 10 9 8 7 6 5 4 3
    end
  end
  context "lookups" do
    before(:each) do
      @race=FactoryGirl.create(:race)
      @county=FactoryGirl.create(:county)
    end
    it "finds a team for race and county if it exists" do
      @team=FactoryGirl.create(:team,race:@race,title:@county.title)
      expect(Team.with_race_and_title(@race,@county.title)).to eq @team
    end
    it "creates a team for race and county if it exists" do
      expect {
        Team.with_race_and_title(@race,@county.title)
      }.to change(Team,:count).by(1)
    end
  end
end
