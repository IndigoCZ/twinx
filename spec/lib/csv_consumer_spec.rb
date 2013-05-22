require 'csv_consumer'
describe CSVConsumer do
=begin
  before :all do
    class Team; end
    class Category; end
    class County; end
    class Person; end
  end
  it "imports all categories for a race from CSV data" do
    @csv_file="category\nM\nZ35\n"
    @race=double("Race")
    Category.should_receive(:first_or_create_by_code).with(@race,"M")
    Category.should_receive(:first_or_create_by_code).with(@race,"Z35")
    CSVInterface.import(@race,@csv_file)
  end
  it "imports all teams and counties for a race from CSV data" do
    @csv_file="category,team\nM,Moutnice\nZ35,Moutnice\n"
    @race=double("Race")
    @county=double("County")
    Category.stub(:first_or_create_by_code)
    County.should_receive(:first_or_create).with(title:"Moutnice").and_return(@county)
    Team.should_receive(:first_or_create_for_race_and_county).with(@race,@county)
    County.should_receive(:first_or_create).with(title:"Moutnice").and_return(@county)
    Team.should_receive(:first_or_create_for_race_and_county).with(@race,@county)
    CSVInterface.import(@race,@csv_file)
  end
  it "imports all people from CSV data" do
    @csv_file=<<CSV
first_name,last_name,yob,gender,team
Lojzik,Kotrba,1990,male,Moutnice
CSV
    @race=double("Race")
    @county=double("County")
    @person=double("Person")
    @lojzik=OpenStruct.new
    Category.stub(:first_or_create_by_code)
    County.stub(:first_or_create).and_return(@county)
    Team.stub(:first_or_create_for_race_and_county)
    Person.should_receive(:new).and_return(@lojzik)
    Person.should_receive(:attribute_names).and_return(["id", "first_name", "last_name", "full_name", "gender", "yob", "born", "county_id", "id_string", "created_at", "updated_at"])
    @lojzik.should_receive(:save)
    @lojzik.should_receive(:dedup)
    CSVInterface.import(@race,@csv_file)
    @lojzik.first_name.should eq "Lojzik"
    @lojzik.last_name.should eq "Kotrba"
    @lojzik.yob.should eq 1990
    @lojzik.gender.should eq "male"
    @lojzik.county.should eq @county
  end
=end
end
