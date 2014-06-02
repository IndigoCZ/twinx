require 'spec_helper'

describe Result, :type => :model do
  context "Basics" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:result)).to be_valid
    end
    it "is invalid without a participant" do
      expect(FactoryGirl.build(:result, participant_id:nil)).not_to be_valid
    end
    it "is invalid without a position" do
      expect(FactoryGirl.build(:result, position:nil)).not_to be_valid
    end
  end
  context "Time" do
    it "returns a well formatted time" do
      result=FactoryGirl.build(:result)
      result.time_msec=60000
      @duration_instance=double
      expect(Duration).to receive(:from_ms).and_return(@duration_instance)
      expect(result.time).to eq(@duration_instance)
    end
    it "accepts a hash as time value" do
      result=FactoryGirl.build(:result)
      time={"fract"=>"12","sec"=>"1","min"=>"0"}
      expect(Duration).to receive(:from_hash).with(time).and_return(1012) # It actually returns a Duration instance
      result.time=time
    end
    it "accepts a string as time value" do
      result=FactoryGirl.build(:result)
      time="0:1.12"
      expect(Duration).to receive(:from_string).with(time).and_return(1012) # It actually returns a Duration instance
      result.time="0:1.12"
    end
  end
  context "Points" do
    it "assigns 12 points for first place" do
      expect(Result.new(position:1).points).to eq 12
    end
    it "assigns from 10 down to 2 points for second to tenth place" do
      expect(Result.new(position:5).points).to eq 7
    end
    it "assigns 1 point for every other finish" do
      expect(Result.new(position:77).points).to eq 1
    end
  end
  context "Participant" do
    before :each do 
      @result=Result.new()
    end
    it "Provides direct access to participant starting_no and race" do
      participant=FactoryGirl.create(:participant)
      @result.participant=participant
      expect(@result.starting_no).to eq participant.starting_no
      expect(@result.race).to eq participant.race
    end
    it "Provides a way to store starting_no and race" do
      race=FactoryGirl.create(:race)
      @result.starting_no=11
      expect(@result.starting_no).to eq 11
      @result.race=race
      expect(@result.race).to eq race
    end
    it "Provides a way to lookup a participant" do
      participant=FactoryGirl.create(:participant)
      @result.starting_no=participant.starting_no
      @result.race=participant.race
      expect(@result.participant_lookup).to eq participant
    end
    it "Lookup can ignore participants with results" do
      existing_result=FactoryGirl.create(:result)
      participant=existing_result.participant
      @result.starting_no=participant.starting_no
      @result.race=participant.race
      expect(@result.participant_lookup).to eq nil
      participant.result.delete
      expect(@result.participant_lookup).to eq participant
    end
  end
  context "Sorting and filtering" do
    it "provides sort query strings" do
      expect(Result.sort_by).to eq("position")
      expect(Result.sort_by("team")).to eq("counties.title")
      expect(Result.sort_by("category")).to eq("categories.sort_order")
    end
    it "provides a filter_by method" do
      team=FactoryGirl.create(:team)
      participant=FactoryGirl.create(:participant,team:team)
      result=FactoryGirl.create(:result,participant:participant)
      expect(Result.filter_by("team_#{team.id}").first.id).to eq(result.id)
    end
  end
  context "Deprecated" do
    it "provides a race filter" do
      result=FactoryGirl.create(:result)
      expect(Result.for_race(result.participant.race).first.id).to eq(result.id)
    end
  end
end
