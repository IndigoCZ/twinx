require 'csv_interface'
describe CSVInterface do
  it "provides a list of valid fields" do
    %w[starting_no first_name last_name full_name gender yob team category position time born id_string].each do |field_name|
      CSVInterface.valid_field?(field_name).should be_true
    end
  end
  it "can check that a header only contains valid fields" do
    CSVInterface.check_header(%w[starting_no full_name]).should be_true
    CSVInterface.check_header(%w[xxx]).should be_false
  end
  it "can check that a header contains all required fields" do
    CSVInterface.check_header(%w[starting_no full_name],%w[full_name]).should be_true
    CSVInterface.check_header(%w[starting_no],%w[full_name]).should be_false
  end
  context "Export" do
    it "raises an exception when passed an invalid header" do
     expect {
       CSVInterface.export([],["participant_id"])
     }.to raise_error(CSVInterface::InvalidField)
    end
    it "returns a CSV with header" do
      CSVInterface.export([],["starting_no","full_name"]).should eq "starting_no,full_name\n"
    end
    it "instantiates a CSVPresenter for each participant and forwards all queries to it" do
      @participant=stub
      @csv_presenter=stub
      CSVPresenter.should_receive(:new).with(@participant).and_return(@csv_presenter)
      @csv_presenter.should_receive(:starting_no).and_return(1)
      @csv_presenter.should_receive(:full_name).and_return("Lojzik")
      CSVInterface.export([@participant],["starting_no","full_name"]).should eq "starting_no,full_name\n1,Lojzik\n"
    end
  end
  context "Import" do
    it "supports import" do
      @race=double("Race")
      @race.stub(:id).and_return(101)
      @c1=double("Consumer")
      @c2=double("Consumer")
      @csv_file=<<CSV
starting_no,first_name,last_name,yob,gender,team,category,position,time
1,Lojzik,Kotrba,1990,male,Moutnice,M,11,1:22:345
2,Radmila,Kozena,1950,female,Moutnice,Z35,1,""
CSV
      CSVConsumer.should_receive(:new).with({
        "starting_no"=>"1",
        "first_name"=>"Lojzik",
        "last_name"=>"Kotrba",
        "yob"=>"1990",
        "gender"=>"male",
        "team"=>"Moutnice",
        "category"=>"M",
        "position"=>"11",
        "time"=>"1:22:345"}).and_return(@c1)
      @c1.should_receive(:save)
      CSVConsumer.should_receive(:new).with({
        "starting_no"=>"2",
        "first_name"=>"Radmila",
        "last_name"=>"Kozena",
        "yob"=>"1950",
        "gender"=>"female",
        "team"=>"Moutnice",
        "category"=>"Z35",
        "position"=>"1",
        "time"=>""}).and_return(@c2)
      @c2.should_receive(:save)
      CSVInterface.import(@race,@csv_file)
    end
  end
end
