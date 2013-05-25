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
