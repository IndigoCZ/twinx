require 'spec_helper'

describe Person do
  context "Model basics" do
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
  end
  context "Merging" do
    before :each do
      @person1=FactoryGirl.create(:person)
      @person2=@person1.dup
      @person2.id_string="MERGE THIS"
      @person2.save
      @person3=@person1.dup
      @person3.born=Date.new(@person3.yob,1,1)
      @person3.save
    end
    it "Can merge two people" do
      participant1=FactoryGirl.create(:participant, person_id:@person1.id)
      participant2=FactoryGirl.create(:participant, person_id:@person2.id)
      participant3=FactoryGirl.create(:participant, person_id:@person3.id)
      @person1.merge(@person2)
      @person2.persisted?.should be_false
      @person1.id_string.should eq "MERGE THIS"
      @person1.merge(@person3)
      @person3.persisted?.should be_false
      @person1.born.should eq Date.new(@person1.yob,1,1)
      @person1.participants.should eq [participant1,participant2,participant3]
    end
    it "Can locate a duplicate person" do
      @person1.find_dupes.should eq [@person2,@person3]
    end
    it "Can deduplicate two identical people" do
      @person1.dedup
      @person1.id_string.should eq "MERGE THIS"
      @person1.born.should eq Date.new(@person1.yob,1,1)
    end
  end
  context "Complex interactions" do
=begin
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
      DatabaseCleaner.clean
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
      DatabaseCleaner.clean
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
=end
    it "Updates the born date with YOB before saving" do
      person=FactoryGirl.build(:person,yob:1977)
      person.born=Date.new(1,5,13)
      person.save
      person.born.to_s.should be == "1977-05-13"
    end
  end
end
