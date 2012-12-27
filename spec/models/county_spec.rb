require 'spec_helper'

describe County do
  it "has a valid factory" do
     FactoryGirl.create(:county).should be_valid
  end
  it "is invalid without a title" do
     FactoryGirl.build(:county, title:nil).should_not be_valid
  end
  it "requires a unique county title" do
     c1=County.new(title:"Duplicate")
     c2=County.new(title:"Duplicate")
     c2.should be_valid
     c1.should be_valid
     c1.save
     c2.should_not be_valid
  end
end
