require 'spec_helper'

describe Constraint, :type => :model do
  it "has a valid factory" do
     expect(FactoryGirl.create(:constraint)).to be_valid
  end
  it "is invalid without a restrict clause" do
     expect(FactoryGirl.build(:constraint, restrict:nil)).not_to be_valid
  end
  it "returns its difficulty when queried" do
     easy=FactoryGirl.build(:constraint,restrict:"max_age",integer_value:5)
     hard=FactoryGirl.build(:constraint,restrict:"max_age",integer_value:10)
     expect(hard.difficulty).to be > easy.difficulty
     easy=FactoryGirl.build(:constraint,restrict:"min_age",integer_value:80)
     hard=FactoryGirl.build(:constraint,restrict:"min_age",integer_value:60)
     expect(hard.difficulty).to be > easy.difficulty
  end
  it "returns maximum difficulty for gender restriction" do
    expect(FactoryGirl.create(:constraint,restrict:"gender",string_value:"male").difficulty).to be Constraint::MAX_DIFFICULTY
  end
  it "returns the appropriate value when queried" do

  end
  it "is invalid without a proper value" do
     expect(FactoryGirl.build(:constraint, restrict:"gender",integer_value:10, string_value:nil)).not_to be_valid
     expect(FactoryGirl.build(:constraint, restrict:"max_age", integer_value:nil, string_value:"aaaa")).not_to be_valid
  end
end
