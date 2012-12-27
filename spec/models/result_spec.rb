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
  it "returns a well formatted time"
end
