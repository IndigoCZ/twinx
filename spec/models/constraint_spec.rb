require 'spec_helper'

describe Constraint do
  it "has a valid factory" do
     FactoryGirl.create(:constraint).should be_valid
  end
  it "is invalid without a restrict clause" do
     FactoryGirl.build(:constraint, restrict:nil).should_not be_valid
  end
  it "returns its difficulty when queried" do
     easy=FactoryGirl.build(:constraint,restrict:"max_age",integer_value:5)
     hard=FactoryGirl.build(:constraint,restrict:"max_age",integer_value:10)
     hard.difficulty.should be > easy.difficulty
     easy=FactoryGirl.build(:constraint,restrict:"min_age",integer_value:80)
     hard=FactoryGirl.build(:constraint,restrict:"min_age",integer_value:60)
     hard.difficulty.should be > easy.difficulty
  end
  it "returns maximum difficulty for gender restriction" do
    FactoryGirl.create(:constraint,restrict:"gender",string_value:"male").difficulty.should be Constraint::MAX_DIFFICULTY
  end
  it "is invalid without a proper value" do
     FactoryGirl.build(:constraint, restrict:"gender",integer_value:10, string_value:nil).should_not be_valid
     FactoryGirl.build(:constraint, restrict:"max_age", integer_value:nil, string_value:"aaaa").should_not be_valid
  end
end
