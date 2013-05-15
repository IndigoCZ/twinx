require 'category_picker'
require 'spec_helper'
describe CategoryPicker do
  before(:each) do
    @race=FactoryGirl.create(:race)
    @muzi=FactoryGirl.create(:category,title:"Muzi",race:@race)
    FactoryGirl.create(:constraint,category:@muzi,restrict:"gender",string_value:"male")
    @zeny=FactoryGirl.create(:category,title:"Zeny",race:@race)
    FactoryGirl.create(:constraint,category:@zeny,restrict:"gender",string_value:"female")
    @zeny.constraints.reload
    @seniori=FactoryGirl.create(:category,title:"Seniori",race:@race)
    FactoryGirl.create(:constraint,category:@seniori,restrict:"gender",string_value:"male")
    FactoryGirl.create(:constraint,category:@seniori,restrict:"min_age",integer_value:60)
    @seniori.constraints.reload
    @juniori=FactoryGirl.create(:category,title:"Juniori",race:@race)
    FactoryGirl.create(:constraint,category:@juniori,restrict:"max_age",integer_value:20)
    FactoryGirl.create(:constraint,category:@juniori,restrict:"gender",string_value:"male")
    @juniori.constraints.reload
  end
  it "provides gender specific scope" do
    CategoryPicker.pick(@race,gender:"female").count.should eq 1
  end
  it "provides age specific scope" do
    CategoryPicker.pick(@race,gender:"male",age:70).count.should eq 2
    CategoryPicker.pick(@race,gender:"male",age:30).count.should eq 1
    CategoryPicker.pick(@race,gender:"male",age:15).count.should eq 2
  end
end
