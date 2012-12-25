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

  it "updates a county when I fill in the edit county form" do
    county.save
    visit edit_county_path(county.id)
    fill_in "Název", with: "Some other name"
    click_button "Uložit Jednotu"
    page.should have_content("Jednota byla úspěšně upravena.")
  end

  it "shows a listing of counties when visit the index" do
    county.save
    visit counties_path
    page.should have_content "Přehled Jednot"
    page.should have_content county.title
  end

  it "deletes a county when I click the delete button", js:true do
    DatabaseCleaner.clean
    county.save
    visit counties_path
    page.should have_content county.title
    page.should have_content "Smazat"
    expect{
      click_link 'Smazat'
      page.driver.accept_js_confirms!
    }.to change(County,:count).by(-1)
    page.should have_content "Přehled Jednot"
    page.should_not have_content county.title
  end

end
