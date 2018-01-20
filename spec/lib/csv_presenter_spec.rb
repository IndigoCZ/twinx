require 'csv_presenter'
describe CSVPresenter do
  before :each do
    @participant=double("Participant")
    @person=double("Person")
    @team=double("Team")
    @team_type=double("TeamType")
    @county=double("County")
    @category=double("Category")
    @result=double("Result")
    allow(@participant).to receive(:person).and_return(@person)
    allow(@participant).to receive(:team).and_return(@team)
    allow(@participant).to receive(:category).and_return(@category)
    allow(@participant).to receive(:result).and_return(@result)
    allow(@team).to receive(:county).and_return(@county)
    allow(@team).to receive(:team_type).and_return(@team_type)
  end
  it "loads up the person, result, team and category for the Participant when instantiated" do
    expect(@participant).to receive(:person)
    expect(@participant).to receive(:result)
    expect(@participant).to receive(:team)
    expect(@participant).to receive(:category)
    CSVPresenter.new(@participant)
  end
  it "presents a NullResult when no result is found" do
    expect(@participant).to receive(:result).and_return(nil)
    presenter=CSVPresenter.new(@participant)
    expect(presenter.position).to eq "DNF"
    expect(presenter.time).to eq nil
  end
  it "forwards the methods to relevant objects" do
    presenter=CSVPresenter.new(@participant)
    expect(@participant).to receive(:starting_no)
    presenter.starting_no
    expect(@person).to receive(:first_name)
    presenter.first_name
    expect(@result).to receive(:time)
    presenter.time
    expect(@county).to receive(:title)
    presenter.team
    expect(@team_type).to receive(:title)
    presenter.ttype
    expect(@category).to receive(:code)
    presenter.category
  end
end
