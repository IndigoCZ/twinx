require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    @person = Person.new
    @person.first_name="Kryspin"
    @person.last_name="Jeviste"
    @person.yob=1950
    @person.county_id=County.first.id
    @person.sex="male"
  end
  test "should save a valid person" do
    assert @person.save
  end
  test "person without first name is invalid" do
    @person.first_name=nil
    assert @person.invalid?
  end
  test "person without last name is invalid" do
    @person.last_name=nil
    assert @person.invalid?
  end
  test "person without YOB is invalid" do
    @person.yob=nil
    assert @person.invalid?
    @person.yob=1850
    assert @person.invalid?
    @person.yob=Time.now.year+1
    assert @person.invalid?
  end
  test "person without county is invalid" do
    @person.county_id=nil
    assert @person.invalid?
    @person.county_id=999999
    assert @person.invalid?
  end
  test "person without sex is invalid" do
    @person.sex=nil
    assert @person.invalid?
  end
end
