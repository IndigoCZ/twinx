require 'spec_helper'

describe Category do
  it "has a valid factory" do
     FactoryGirl.create(:category).should be_valid
  end
  it "is invalid without a race" do
     FactoryGirl.build(:category, race_id:nil).should_not be_valid
  end
  it "is invalid without a title" do
     FactoryGirl.build(:category, title:nil).should_not be_valid
  end
end
