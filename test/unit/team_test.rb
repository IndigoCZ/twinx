require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = Team.new
    @team.race_id=Race.first.id
    @team.county_id=County.first.id
  end
  test "team without race is invalid" do
    @team.race_id=nil
    assert @team.invalid?
    @team.race_id=999999
    assert @team.invalid?
  end
  test "team without county is invalid" do
    @team.county_id=nil
    assert @team.invalid?
    @team.county_id=999999
    assert @team.invalid?
  end
  test "valid team is valid" do
    assert @team.save
  end
end
