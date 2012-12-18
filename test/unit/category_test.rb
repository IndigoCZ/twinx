require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = Category.new
    @category.race_id = Race.first.id
    @category.title="Proper category"
  end
  test "category without a race is invalid" do
    @category.race_id=nil
    assert @category.invalid?
    @category.race_id=999999
    assert @category.invalid?
  end
  test "category without a title is invalid" do
    @category.title=nil
    assert @category.invalid?
  end
  test "valid category is valid" do
    assert @category.valid?
  end
end
