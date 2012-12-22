require 'spec_helper'

describe Participant do
  it "has a valid factory" do
     FactoryGirl.create(:participant).should be_valid
  end
  it "is invalid without a person" do
     FactoryGirl.build(:participant, person_id:nil).should_not be_valid
  end
  it "is invalid without a team" do
     FactoryGirl.build(:participant, team_id:nil).should_not be_valid
  end
  it "is invalid without a category" do
     FactoryGirl.build(:participant, category_id:nil).should_not be_valid
  end
  it "is invalid without a starting number" do
     FactoryGirl.build(:participant, starting_no:nil).should_not be_valid
  end
end
