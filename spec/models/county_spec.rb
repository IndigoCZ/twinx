require 'spec_helper'

describe County do
  it "has a valid factory" do
     FactoryGirl.create(:county).should be_valid
  end
  it "is invalid without a title" do
     FactoryGirl.build(:county, title:nil).should_not be_valid
  end
end
