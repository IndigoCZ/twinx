require 'test_helper'

class CategoryConstraintTest < ActiveSupport::TestCase
  setup do
    @constraint = CategoryConstraint.new
    @constraint.category_id = Category.first.id
    @constraint.type = "min_age"
    @constraint.value = "18"
  end
  test "constraint without category is invalid" do
    @constraint.category_id = nil
    assert @constraint.invalid?
    @constraint.category_id = 999999
    assert @constraint.invalid?
  end
  test "constraint without type is invalid" do
    @constraint.type = nil
    assert @constraint.invalid?
  end
  test "constraint without value is invalid" do
    @constraint.value = nil
    assert @constraint.invalid?
  end
  test "valid constraint is valid" do
    assert @constraint.valid?
  end
end
