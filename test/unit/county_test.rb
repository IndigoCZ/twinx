require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  setup do
    @county = County.new
    @county.title="Sample county"
  end
  test "county without title is invalid" do
    @county.title=nil
    assert @county.invalid?
  end
  test "valid county is valid" do
    assert @county.valid?
  end
end
