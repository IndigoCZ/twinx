require 'test_helper'

class RaceTest < ActiveSupport::TestCase
  setup do
    @race = Race.new
    @race.title="Sample race"
    @race.held_on=1.day.from_now
  end
  test "race without title is invalid" do
    @race.title=nil
    assert @race.invalid?
  end
  test "race without date is invalid" do
    @race.held_on=nil
    assert @race.invalid?
  end
  test "valid race is valid" do
    assert @race.valid?
  end
end
