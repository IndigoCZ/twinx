require 'spec_helper'

describe County, :type => :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:county)).to be_valid
  end
  it "is invalid without a title" do
    expect(FactoryGirl.build(:county, title:nil)).not_to be_valid
  end
  it "requires a unique county title" do
    DatabaseCleaner.clean
    c1=County.new(title:"Duplicate")
    expect(c1).to be_valid
    c2=County.new(title:"Duplicate")
    expect(c2).to be_valid
    c1.save
    expect(c2).not_to be_valid
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
