require 'spec_helper'

describe Participant, :type => :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:participant)).to be_valid
  end
  it "is invalid without a person" do
    expect(FactoryGirl.build(:participant, person_id:nil)).not_to be_valid
  end
  it "is invalid without a team" do
    expect(FactoryGirl.build(:participant, team_id:nil)).not_to be_valid
  end
  it "is invalid without a category" do
    expect(FactoryGirl.build(:participant, category_id:nil)).not_to be_valid
  end
  it "is invalid without a starting number" do
    expect(FactoryGirl.build(:participant, starting_no:nil)).not_to be_valid
  end
  it "is invalid with a duplicate starting number" do
    race=FactoryGirl.create(:race)
    category=FactoryGirl.create(:category, race:race)
    expect(FactoryGirl.create(:participant, category:category, starting_no:123)).to be_valid
    expect(FactoryGirl.build(:participant, category:category, starting_no:123)).not_to be_valid
  end
  it "provides a race filter" do
    participant=FactoryGirl.create(:participant)
    expect(Participant.for_race(participant.race).first.id).to eq(participant.id)
  end
  it "provides sort query strings" do
    expect(Participant.sort_by).to eq("starting_no")
    expect(Participant.sort_by("team")).to eq("counties.title")
    expect(Participant.sort_by("category")).to eq("categories.sort_order")
  end
  it "provides group query strings" do
    expect(Participant.group_by).to eq("categories.sort_order")
    expect(Participant.group_by("team")).to eq("counties.title")
    expect(Participant.group_by("category")).to eq("categories.sort_order")
  end
  it "provides a filter_by method" do
    team=FactoryGirl.create(:team)
    participant=FactoryGirl.create(:participant,team:team)
    expect(Participant.filter_by("team_#{team.id}").first.id).to eq(participant.id)
  end
end
