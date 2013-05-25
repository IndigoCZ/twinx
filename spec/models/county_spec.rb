require 'spec_helper'

describe County do
  it "has a valid factory" do
    FactoryGirl.create(:county).should be_valid
  end
  it "is invalid without a title" do
    FactoryGirl.build(:county, title:nil).should_not be_valid
  end
  it "requires a unique county title" do
    DatabaseCleaner.clean
    c1=County.new(title:"Duplicate")
    c1.should be_valid
    c2=County.new(title:"Duplicate")
    c2.should be_valid
    c1.save
    c2.should_not be_valid
  end
  it "can be deleted when empty" do
    @county=FactoryGirl.create(:county)
    expect {
      @county.destroy
    }.to change(County,:count).by(-1)
  end
  it "cannot be deleted while it has people" do
    @county=FactoryGirl.create(:county)
    FactoryGirl.create(:person,county:@county)
    expect {
      @county.destroy
    }.not_to change(County,:count)
  end
  it "cannot be deleted while it has teams" do
    @county=FactoryGirl.create(:county)
    FactoryGirl.create(:team,county:@county)
    expect {
      @county.destroy
    }.not_to change(County,:count)
  end
end
