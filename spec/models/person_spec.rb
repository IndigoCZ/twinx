require 'spec_helper'

describe Person do
  it "has a valid factory" do
     FactoryGirl.create(:person).should be_valid
  end
  it "is invalid without a first name" do
     FactoryGirl.build(:person, first_name:nil).should_not be_valid
  end
  it "is invalid without a last name" do
     FactoryGirl.build(:person, last_name:nil).should_not be_valid
  end
  it "is invalid without a YOB" do
     FactoryGirl.build(:person, yob:nil).should_not be_valid
  end
  it "is invalid when born before 1900" do
     FactoryGirl.build(:person, yob:1899).should_not be_valid
  end
  it "is invalid when born in the future YOB" do
     FactoryGirl.build(:person, yob:(Time.now.year+1)).should_not be_valid
  end
  it "is invalid without a county" do
     FactoryGirl.build(:person, county_id:nil).should_not be_valid
  end
  it "is invalid without gender" do
     FactoryGirl.build(:person, gender:nil).should_not be_valid
  end
  it "is invalid with a gender other than male/female" do
     FactoryGirl.build(:person, gender:"none").should_not be_valid
  end
end
