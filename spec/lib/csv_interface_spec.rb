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
      CSVPresenter.should_receive(:new).with(@participant).and_return(@csv_presenter)
      @csv_presenter.should_receive(:starting_no).and_return(1)
      @csv_presenter.should_receive(:full_name).and_return("Lojzik")
      CSVInterface.export([@participant],["starting_no","full_name"]).should eq "starting_no,full_name\n1,Lojzik\n"
    end
  end
  context "Import" do
    it "imports all participants for a race in CSV format"
  end
end
