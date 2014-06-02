# encoding: UTF-8
require 'spec_helper'

describe "Teams", :type => :feature do
  let(:race) { FactoryGirl.create(:race) }
  let(:team) { FactoryGirl.build(:team, race_id:race.id)}

  it "shows a listing of teams when I visit /" do
    team.save
    visit race_teams_path(:race_id => race.id)
    expect(page).to have_content("Přehled týmů")
    expect(page).to have_content(team.title)
  end
end
