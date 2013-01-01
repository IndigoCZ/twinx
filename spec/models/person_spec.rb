require 'spec_helper'

describe Person do
  it "has a valid factory" do
    FactoryGirl.build(:person).should be_valid
  end
  it "is invalid without a first name" do
    FactoryGirl.build(:person, first_name:nil).should_not be_valid
  end
  it "is invalid without a last name" do
    FactoryGirl.build(:person, last_name:nil).should_not be_valid
  end
  it "is invalid without a YOB" do
    FactoryGirl.build(:person, yob:nil).should_not be_valid
  end
  it "is invalid when born before 1900" do
    FactoryGirl.build(:person, yob:1899).should_not be_valid
  end
  it "is invalid when born in the future YOB" do
    FactoryGirl.build(:person, yob:(Time.now.year+1)).should_not be_valid
  end
  it "is invalid without a county" do
    FactoryGirl.build(:person, county_id:nil).should_not be_valid
  end
  it "is invalid without gender" do
    FactoryGirl.build(:person, gender:nil).should_not be_valid
  end
  it "is invalid with a gender other than male/female" do
    FactoryGirl.build(:person, gender:"none").should_not be_valid
  end
  it "provides a finder for existing people" do
    person=FactoryGirl.create(:person)
    lookup=Person.lookup_or_create(
      "first_name"=>person.first_name,
      "last_name"=>person.last_name,
      "yob"=>person.yob,
      "gender"=>person.gender,
      "county_id"=>person.county_id
    )
    person.id.should be == lookup.id
  end
  it "finder for existing people returns a new person when none exists" do
    person=FactoryGirl.create(:person)
    lookup=Person.lookup_or_create(
      "first_name"=>person.last_name,
      "last_name"=>person.first_name,
      "yob"=>person.yob,
      "gender"=>person.gender,
      "county_id"=>person.county_id
    )
    person.id.should_not be == lookup.id
  end
  it "raises an exception for the edge case where two people have the same credentials but a different id_string when the id_string is not specified in lookup" do
    template=FactoryGirl.build(:person)
    person1=template.dup
    person1.id_string="ABC"
    person1.save
    person2=template.dup
    person2.id_string="DEF"
    person2.save
    expect {
    lookup=Person.lookup_or_create(
      "first_name"=>template.first_name,
      "last_name"=>template.last_name,
      "yob"=>template.yob,
      "gender"=>template.gender,
      "county_id"=>template.county_id
    )
    }.to raise_error
  end
  it "handles the edge case where two people have the same credentials but a different id_string when the id_string is specified in lookup" do
    template=FactoryGirl.build(:person)
    person1=template.dup
    person1.id_string="ABC"
    person1.save
    person2=template.dup
    person2.id_string="DEF"
    person2.save
    lookup=Person.lookup_or_create(
      "first_name"=>template.first_name,
      "last_name"=>template.last_name,
      "yob"=>template.yob,
      "gender"=>template.gender,
      "county_id"=>template.county_id,
      "id_string"=>"ABC"
    )
    person1.id.should be == lookup.id
  end
end
