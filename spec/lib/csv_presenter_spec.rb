require 'csv_presenter'
describe CSVPresenter do
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
    CSVPresenter.new(@participant)
  end
  it "presents a NullResult when no result is found" do
    @participant.should_receive(:result).and_return(nil)
    presenter=CSVPresenter.new(@participant)
    presenter.position.should eq "DNF"
    presenter.time.should eq nil
  end
  it "forwards the methods to relevant objects" do
    presenter=CSVPresenter.new(@participant)
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
