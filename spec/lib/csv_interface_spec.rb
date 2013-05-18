require 'csv_interface'
describe CSVInterface do
  it "provides a list of valid fields" do
    %w[starting_no first_name last_name full_name gender yob team category position time born id_string].each do |field_name|
      CSVInterface.valid_field?(field_name).should be_true
    end
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
      CSVInterface::CSVPresenter.should_receive(:new).with(@participant).and_return(@csv_presenter)
      @csv_presenter.should_receive(:starting_no).and_return(1)
      @csv_presenter.should_receive(:full_name).and_return("Lojzik")
      CSVInterface.export([@participant],["starting_no","full_name"]).should eq "starting_no,full_name\n1,Lojzik\n"
    end
  end
  context "CSVPresenter" do
    before :each do
      @participant=double("Participant")
      @person=double("Person")
      @team=double("Person")
      @category=double("Category")
      @result=double("Team")
      @participant.stub(:person).and_return(@person)
      @participant.stub(:team).and_return(@team)
      @participant.stub(:category).and_return(@category)
      @participant.stub(:result).and_return(@result)
    end
    it "loads up the person, result, team and category for the Participant when instantiated" do
      @participant.should_receive(:person)
      @participant.should_receive(:result)
      @participant.should_receive(:team)
      @participant.should_receive(:category)
      CSVInterface::CSVPresenter.new(@participant)
    end
    it "forwards the methods to relevant objects" do
      presenter=CSVInterface::CSVPresenter.new(@participant)
      @participant.should_receive(:starting_no)
      presenter.starting_no
      @person.should_receive(:first_name)
      presenter.first_name
      @result.should_receive(:time)
      presenter.time
      @team.should_receive(:title)
      presenter.team
      @category.should_receive(:code)
      presenter.category
    end
  end
  context "Import" do
    it "imports all participants for a race in CSV format"
  end
end
