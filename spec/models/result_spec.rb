require 'spec_helper'

describe Result do
  it "has a valid factory" do
     FactoryGirl.create(:result).should be_valid
  end
  it "is invalid without a participant" do
     FactoryGirl.build(:result, participant_id:nil).should_not be_valid
  end
  it "is invalid without a position" do
     FactoryGirl.build(:result, position:nil).should_not be_valid
  end
  it "returns a well formatted time" do
     result=FactoryGirl.build(:result)
     result.time_msec=60000
     result.time.should be == "1:00.000"
     result.time_msec=123456
     result.time.should be == "2:03.456"
     result.time_msec=59999
     result.time.should be == "0:59.999"
     result.time_msec=1
     result.time.should be == "0:00.001"
  end
  it "accepts a hash as time value" do
    result=FactoryGirl.build(:result)
    time={"fract"=>"12","sec"=>"1","min"=>"0"}
    result.time=time
    result.time.should be == "0:01.120"
  end
  it "accepts a string as time value" do
    result=FactoryGirl.build(:result)
    result.time="0:1.12"
    result.time.should be == "0:01.120"
  end
  it "provides a race filter" do
    result=FactoryGirl.create(:result)
    Result.for_race(result.participant.race).first.id.should be == result.id
  end
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
