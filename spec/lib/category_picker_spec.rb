require 'category_picker'

FakeConstraint=Struct.new(:restrict,:value)
FakeCategory=Struct.new(:constraints,:difficulty)
def mk_cat(constraints,difficulty)
  constraints_list=[]
  if !constraints.empty?
    constraints.split(",").each do |const|
      constraints_list<<mk_const(const)
    end
  end
  FakeCategory.new(constraints_list,difficulty)
end
def mk_const(constraint)
  restrict,value=constraint.split(":")
  value=value.to_i if restrict.include? "age"
  FakeConstraint.new(restrict,value)
end

describe CategoryPicker do
  it "can filter categories that fit the gender condition" do
    @male_cat=mk_cat("gender:male",0)
    @female_cat=mk_cat("gender:female",0)
    CategoryPicker.new([@male_cat,@female_cat]).pick(gender:"male",age:10).should eq [@male_cat]
  end
  it "can filter categories that fit the age condition" do
    @old_cat=mk_cat("min_age:10",11)
    @young_cat=mk_cat("max_age:10",9)
    @picker=CategoryPicker.new([@old_cat,@young_cat])
    @picker.pick(gender:"male",age:9).should eq [@young_cat]
    @picker.pick(gender:"male",age:10).should eq [@old_cat,@young_cat]
    @picker.pick(gender:"male",age:11).should eq [@old_cat]
  end
  it "orders categories by difficulty in descending order" do
    @unordered_cats=[1,7,3,9,5].map { |i| mk_cat("",i) }
    @ordered_cats=[9,7,5,3,1].map { |i| mk_cat("",i) }
    CategoryPicker.new(@unordered_cats).pick(gender:"male",age:0).should eq @ordered_cats
  end
  it "converts YOB to age" do
    @cat=mk_cat("max_age:10",0)
    CategoryPicker.new([@cat]).pick(gender:"male",yob:Time.now.year - 11).should eq []
    CategoryPicker.new([@cat]).pick(gender:"male",yob:Time.now.year - 10).should eq [@cat]
  end
end
