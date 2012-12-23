# encoding: UTF-8
require 'spec_helper'

describe "Teams" do
  let(:race) { FactoryGirl.create(:race) }
  let(:county) { FactoryGirl.create(:county) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id)}

  it "shows a listing of teams when I visit /" do
    team.save
    visit race_teams_path(:race_id => race.id)
    page.should have_content("Přehled týmů")
    page.should have_content(team.county.title)
  end
end
