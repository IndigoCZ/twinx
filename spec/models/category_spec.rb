require 'spec_helper'

describe Category do
  it "has a valid factory" do
     FactoryGirl.create(:category).should be_valid
  end
  it "is invalid without a race" do
     FactoryGirl.build(:category, race_id:nil).should_not be_valid
  end
  it "is invalid without a title" do
     FactoryGirl.build(:category, title:nil).should_not be_valid
  end
  it "provides gender specific scope" do
    race=FactoryGirl.create(:race)
    muzi=FactoryGirl.create(:category,title:"Muzi",race:race)
    FactoryGirl.create(:constraint,category:muzi,restrict:"gender",string_value:"male")
    zeny=FactoryGirl.create(:category,title:"Zeny",race:race)
    FactoryGirl.create(:constraint,category:zeny,restrict:"gender",string_value:"female")
    race.categories.for_gender("female").count.should eq 1
  end
  it "provides age specific scope" do
    race=FactoryGirl.create(:race)
    muzi=FactoryGirl.create(:category,title:"Muzi",race:race)
    seniori=FactoryGirl.create(:category,title:"Seniori",race:race)
    FactoryGirl.create(:constraint,category:seniori,restrict:"min_age",integer_value:60)
    juniori=FactoryGirl.create(:category,title:"Juniori",race:race)
    FactoryGirl.create(:constraint,category:juniori,restrict:"max_age",integer_value:20)
    race.categories.for_age(70).count.should eq 2
    race.categories.for_age(30).count.should eq 1
    race.categories.for_age(15).count.should eq 2
  end
end
