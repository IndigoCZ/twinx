require 'spec_helper'

describe Category do

  before(:each) do
    @race=FactoryGirl.create(:race)
    @muzi=FactoryGirl.build(:category,title:"Muzi",race:@race)
    @zeny=FactoryGirl.build(:category,title:"Zeny",race:@race)
    @seniori=FactoryGirl.build(:category,title:"Seniori",race:@race)
    @juniori=FactoryGirl.build(:category,title:"Juniori",race:@race)
    @muzi.save
    FactoryGirl.create(:constraint,category:@muzi,restrict:"gender",string_value:"male")
    @zeny.save
    FactoryGirl.create(:constraint,category:@zeny,restrict:"gender",string_value:"female")
    @seniori.save
    FactoryGirl.create(:constraint,category:@seniori,restrict:"min_age",integer_value:60)
    FactoryGirl.create(:constraint,category:@seniori,restrict:"gender",string_value:"male")
    @juniori.save
    FactoryGirl.create(:constraint,category:@juniori,restrict:"max_age",integer_value:20)
    FactoryGirl.create(:constraint,category:@juniori,restrict:"gender",string_value:"male")
  end
  it "has a valid factory" do
    FactoryGirl.create(:category).should be_valid
  end
  it "is invalid without a race" do
    FactoryGirl.build(:category, race_id:nil).should_not be_valid
  end
  it "is invalid without a title" do
    FactoryGirl.build(:category, title:nil).should_not be_valid
  end
  it "calculates own difficulty based on restrictions" do
    @seniori.difficulty
    @muzi.difficulty
    @seniori.difficulty.should be < @muzi.difficulty
  end
  it "provides gender specific scope" do
    @race.categories.for_gender("female").count.should eq 1
  end
  it "provides age specific scope" do
    @race.categories.for_gender("male").for_age(70).count.should eq 2
    @race.categories.for_gender("male").for_age(30).count.should eq 1
    @race.categories.for_gender("male").for_age(15).count.should eq 2
  end
end
