require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :race_id => Race.first.id
    assert_response :success
    assert_not_nil assigns(:teams)
  end
  #
  #
  # Missing test to ensure team with participants cannot be deleted
  #
  #
end
