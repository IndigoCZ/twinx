require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
   setup do
    @participant = Participant.new
    @participant.category_id = Category.first.id
    @participant.person_id = Person.first.id
    @participant.team_id = Team.first.id
    @participant.starting_no=1111
  end
  test "participant without a category is invalid" do
    @participant.category_id=nil
    assert @participant.invalid?
    @participant.category_id=999999
    assert @participant.invalid?
  end
  test "participant without a person is invalid" do
    @participant.person_id=nil
    assert @participant.invalid?
    @participant.person_id=999999
    assert @participant.invalid?
  end
  test "participant without a team is invalid" do
    @participant.team_id=nil
    assert @participant.invalid?
    @participant.team_id=999999
    assert @participant.invalid?
  end
  test "should not save participant without a starting number" do
    @participant.starting_no=nil
    assert @participant.invalid?
    @participant.starting_no="hello"
    assert @participant.invalid?
  end
  test "valid participant is valid" do
    assert @participant.valid?
  end
end
