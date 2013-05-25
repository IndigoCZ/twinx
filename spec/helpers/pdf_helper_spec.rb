require 'spec_helper'
describe PdfHelper do
  describe "#pdf_table_break" do
    it "adds 50 pts of white space if there is more than 120 pts left on the page" do
      @pdf=double("PDF")
      @pdf.should_receive(:cursor).and_return(150)
      @pdf.should_receive(:move_down).with(50)
      helper.pdf_table_break(@pdf)
    end
    it "it starts a new page if there is 120 pts or less left on the page" do
      @pdf=double("PDF")
      @pdf.should_receive(:cursor).and_return(100)
      @pdf.should_receive(:start_new_page)
      helper.pdf_table_break(@pdf)
    end
  end
  describe "#pdf_grouping"
  describe "#pdf_transform_data"
  describe "#pdf_table_title" do
    it "returns the Team title when passed a Team instance" do
      @team=FactoryGirl.build(:team)
      helper.pdf_table_title(@team).should eq @team.title
    end
    it "returns the Category title when passed a Category instance" do
      @category=FactoryGirl.build(:category)
      helper.pdf_table_title(@category).should eq @category.title
    end
    it "returns nil when passed anything else" do #???
      @table_member="Something else"
      helper.pdf_table_title(@table_member).should be_nil
    end
  end
end
