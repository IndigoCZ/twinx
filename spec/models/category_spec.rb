# encoding: UTF-8
require 'spec_helper'

describe Category do
  context "Model basics" do
    it "has a valid factory" do
      FactoryGirl.build(:category).should be_valid
    end
    it "is invalid without a race" do
      FactoryGirl.build(:category, race_id:nil).should_not be_valid
    end
    it "is invalid without a title" do
      FactoryGirl.build(:category, title:nil).should_not be_valid
    end
    it "provides a scope for current race" do
      race=FactoryGirl.create(:race)
      FactoryGirl.create(:category,race:race)
      race.categories.should be == Category.for_race(race)
    end
    it "can be deleted when empty" do
      @category=FactoryGirl.create(:category)
      expect {
        @category.destroy
      }.to change(Category,:count).by(-1)
    end
    it "will also destroy all it's constraints before deletion" do
      @category=FactoryGirl.create(:category)
      FactoryGirl.create(:constraint,category:@category)
      expect {
        @category.reload
        @category.destroy
      }.to change(Constraint,:count).by(-1)
    end
    it "cannot be deleted while it has participants" do
      @category=FactoryGirl.create(:category)
      FactoryGirl.create(:participant,category:@category)
      expect {
        @category.destroy
      }.not_to change(Category,:count)
    end
  end
  context "Complex Interactions" do
    before(:each) do
      #DatabaseCleaner.clean
      @race=FactoryGirl.create(:race)
      @muzi=FactoryGirl.create(:category,title:"Muzi",race:@race)
      FactoryGirl.build(:constraint,category:@muzi,restrict:"gender",string_value:"male").save
      @zeny=FactoryGirl.create(:category,title:"Zeny",race:@race)
      FactoryGirl.create(:constraint,category:@zeny,restrict:"gender",string_value:"female")
      @zeny.constraints.reload
      @seniori=FactoryGirl.create(:category,title:"Seniori",race:@race)
      FactoryGirl.create(:constraint,category:@seniori,restrict:"gender",string_value:"male")
      FactoryGirl.build(:constraint,category:@seniori,restrict:"min_age",integer_value:60).save
      @seniori.constraints.reload
      @juniori=FactoryGirl.create(:category,title:"Juniori",race:@race)
      FactoryGirl.create(:constraint,category:@juniori,restrict:"max_age",integer_value:20)
      FactoryGirl.create(:constraint,category:@juniori,restrict:"gender",string_value:"male")
      @juniori.constraints.reload
    end
    it "calculates own difficulty based on restrictions" do
      @seniori.difficulty.should be < @muzi.difficulty
    end
    it "provides a short description of its restrictions" do
      @seniori.restriction.should be == "M60+"
      @zeny.restriction.should be == "F"
      @juniori.restriction.should be == "M20-"
    end

    it "provides a list of DNF participants" do
      a=FactoryGirl.create(:participant,category:@juniori, starting_no:123)
      b=FactoryGirl.create(:participant,category:@juniori, starting_no:456)
      FactoryGirl.create(:result,participant:a)
      @juniori.dnfs.should include b
      @juniori.dnfs.should_not include a
    end

    it "returns a list of categories from a ruleset file" do
      Category.categories_from_ruleset["M"]["title"].should eq "Muži A"
    end
    it "creates a category by code with details from ruleset file" do
      Category.first_or_create_by_code(@race,"M").title.should eq "Muži A"
    end
    it "returns a category by code if it exists" do
      @category=FactoryGirl.create(:category,race:@race,code:"M",title:"Other Category")
      Category.first_or_create_by_code(@race,"M").should eq @category
    end
  end
end
