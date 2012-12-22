require 'spec_helper'

describe Race do
  it "has a valid factory" do
     FactoryGirl.create(:race).should be_valid
  end
  it "is invalid without a title" do
     FactoryGirl.build(:race, title:nil).should_not be_valid
  end
  it "is invalid without a held_on date" do
     FactoryGirl.build(:race, held_on:nil).should_not be_valid
  end
end
