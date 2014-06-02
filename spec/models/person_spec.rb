require 'spec_helper'

describe Person, :type => :model do
  context "Model basics" do
    it "has a valid factory" do
      expect(FactoryGirl.build(:person)).to be_valid
    end
    it "is invalid without a first name" do
      expect(FactoryGirl.build(:person, first_name:nil)).not_to be_valid
    end
    it "is invalid without a last name" do
      expect(FactoryGirl.build(:person, last_name:nil)).not_to be_valid
    end
    it "is invalid without a YOB" do
      expect(FactoryGirl.build(:person, yob:nil)).not_to be_valid
    end
    it "is invalid when born before 1900" do
      expect(FactoryGirl.build(:person, yob:1899)).not_to be_valid
    end
    it "is invalid when born in the future YOB" do
      expect(FactoryGirl.build(:person, yob:(Time.now.year+1))).not_to be_valid
    end
    it "is invalid without a county" do
      expect(FactoryGirl.build(:person, county_id:nil)).not_to be_valid
    end
    it "is invalid without gender" do
      expect(FactoryGirl.build(:person, gender:nil)).not_to be_valid
    end
    it "is invalid with a gender other than male/female" do
      expect(FactoryGirl.build(:person, gender:"none")).not_to be_valid
    end
    it "can be deleted when empty" do
      @person=FactoryGirl.create(:person)
      expect {
        @person.destroy
      }.to change(Person,:count).by(-1)
    end
    it "cannot be deleted while it has participants" do
      @person=FactoryGirl.create(:person)
      FactoryGirl.create(:participant,person:@person)
      expect {
        @person.destroy
      }.not_to change(Person,:count)
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
      expect(@person2.persisted?).to be_falsey
      expect(@person1.id_string).to eq "MERGE THIS"
      @person1.merge(@person3)
      expect(@person3.persisted?).to be_falsey
      expect(@person1.born).to eq Date.new(@person1.yob,1,1)
      expect(@person1.participants).to eq [participant1,participant2,participant3]
    end
    it "Can locate a duplicate person" do
      expect(@person1.find_dupes).to eq [@person2,@person3]
    end
    it "Can deduplicate two identical people" do
      @person1.dedup
      expect(@person1.id_string).to eq "MERGE THIS"
      expect(@person1.born).to eq Date.new(@person1.yob,1,1)
    end
  end
  context "Complex interactions" do
    it "Updates the born date with YOB before saving" do
      person=FactoryGirl.build(:person,yob:1977)
      person.born=Date.new(1,5,13)
      person.save
      expect(person.born.to_s).to eq("1977-05-13")
    end
  end
end
