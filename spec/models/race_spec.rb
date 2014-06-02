require 'spec_helper'

describe Race, :type => :model do
  it "has a valid factory" do
     expect(FactoryGirl.create(:race)).to be_valid
  end
  it "is invalid without a title" do
     expect(FactoryGirl.build(:race, title:nil)).not_to be_valid
  end
  it "is invalid without a held_on date" do
     expect(FactoryGirl.build(:race, held_on:nil)).not_to be_valid
  end
  it "can be deleted when empty" do
    @race=FactoryGirl.create(:race)
    expect {
      @race.destroy
    }.to change(Race,:count).by(-1)
  end
  it "cannot be deleted while it has categories" do
    @race=FactoryGirl.create(:race)
    FactoryGirl.create(:category,race:@race)
    expect {
      @race.destroy
    }.not_to change(Race,:count)
  end
  it "cannot be deleted while it has teams" do
    @race=FactoryGirl.create(:race)
    FactoryGirl.create(:team,race:@race)
    expect {
      @race.destroy
    }.not_to change(Race,:count)
  end
end
