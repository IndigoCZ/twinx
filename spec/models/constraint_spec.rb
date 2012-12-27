require 'spec_helper'

describe Constraint do
  it "has a valid factory" do
     FactoryGirl.create(:constraint).should be_valid
  end
  it "is invalid without a restrict clause" do
     FactoryGirl.build(:constraint, restrict:nil).should_not be_valid
  end
  it "is invalid without a value"# do
#     FactoryGirl.build(:constraint, value:nil).should_not be_valid
 # end
end
