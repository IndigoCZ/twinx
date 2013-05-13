require 'csv_interface'
describe CSVInterface do
  it "defines a CSV header" do
    CSVInterface.header.should eq %w[starting_no first_name last_name full_name gender yob team category position time born competing id_string]
  end
  context "Import" do
    it "imports all participants for a race in CSV format"
  end
  context "Export" do
    it "exports all participants for a race in CSV format"
  end
end
