require 'spec_helper'

describe Result do
  context "Basics" do
    it "has a valid factory" do
      FactoryGirl.create(:result).should be_valid
    end
    it "is invalid without a participant" do
      FactoryGirl.build(:result, participant_id:nil).should_not be_valid
    end
    it "is invalid without a position" do
      FactoryGirl.build(:result, position:nil).should_not be_valid
    end
  end
  context "Time" do
    it "returns a well formatted time" do
      result=FactoryGirl.build(:result)
      result.time_msec=60000
      @duration_instance=double
      Duration.should_receive(:from_ms).and_return(@duration_instance)
      result.time.should be == @duration_instance
    end
    it "accepts a hash as time value" do
      result=FactoryGirl.build(:result)
      time={"fract"=>"12","sec"=>"1","min"=>"0"}
      Duration.should_receive(:from_hash).with(time).and_return(1012) # It actually returns a Duration instance
      result.time=time
    end
    it "accepts a string as time value" do
      result=FactoryGirl.build(:result)
      time="0:1.12"
      Duration.should_receive(:from_string).with(time).and_return(1012) # It actually returns a Duration instance
      result.time="0:1.12"
    end
  end
  context "Points" do
    it "assigns 12 points for first place" do
      Result.new(position:1).points.should eq 12
    end
    it "assigns from 10 down to 2 points for second to tenth place" do
      Result.new(position:5).points.should eq 7
    end
    it "assigns 1 point for every other finish" do
      Result.new(position:77).points.should eq 1
    end
  end
  context "Participant" do
    before :each do 
      @result=Result.new()
    end
    it "Provides direct access to participant starting_no and race" do
      participant=FactoryGirl.create(:participant)
      @result.participant=participant
      @result.starting_no.should eq participant.starting_no
      @result.race.should eq participant.race
    end
    it "Provides a way to store starting_no and race" do
      race=FactoryGirl.create(:race)
      @result.starting_no=11
      @result.starting_no.should eq 11
      @result.race=race
      @result.race.should eq race
    end
    it "Provides a way to lookup a participant" do
      participant=FactoryGirl.create(:participant)
      @result.starting_no=participant.starting_no
      @result.race=participant.race
      @result.participant_lookup.should eq participant
    end
    it "Lookup can ignore participants with results" do
      existing_result=FactoryGirl.create(:result)
      participant=existing_result.participant
      @result.starting_no=participant.starting_no
      @result.race=participant.race
      @result.participant_lookup.should eq nil
      participant.result.delete
      @result.participant_lookup.should eq participant
    end
  end
  context "Sorting and filtering" do
    it "provides sort query strings" do
      Result.sort_by.should be == "position"
      Result.sort_by("team").should be == "counties.title"
      Result.sort_by("category").should be == "categories.sort_order"
    end
    it "provides a filter_by method" do
      team=FactoryGirl.create(:team)
      participant=FactoryGirl.create(:participant,team:team)
      result=FactoryGirl.create(:result,participant:participant)
      Result.filter_by("team_#{team.id}").first.id.should be == result.id
    end
  end
  context "Deprecated" do
    it "provides a race filter" do
      result=FactoryGirl.create(:result)
      Result.for_race(result.participant.race).first.id.should be == result.id
    end
  end
end
