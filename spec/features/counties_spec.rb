# encoding: UTF-8
require 'spec_helper'

describe "Counties" do
  let(:county) { FactoryGirl.build(:county) }

  it "shows the new county form when I visit /new" do
    visit new_county_path
    page.should have_content("Nová jednota")
  end

  it "creates a new county when I fill in the new county form" do
    visit new_county_path
    fill_in "Název", with:county.title
    click_button "Vytvořit"
    page.should have_content("Jednota byla úspěšně vytvořena.")
  end
  it "shows details of an existing county when I visit /:county" do
    county.save
    visit county_path(county.id)
    page.should have_content(county.title)
  end
end
