require 'spec_helper'

describe Team do
  it "has a valid factory" do
     FactoryGirl.create(:team).should be_valid
  end
  it "is invalid without a race" do
     FactoryGirl.build(:team, race_id:nil).should_not be_valid
  end
  it "is invalid without a county" do
     FactoryGirl.build(:team, county_id:nil).should_not be_valid
  end
end
