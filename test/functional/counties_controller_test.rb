require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  setup do
    @county = counties(:moutnice)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create county" do
    assert_difference('County.count') do
      post :create, county: { title: @county.title }
    end

    assert_redirected_to county_path(assigns(:county))
  end

  test "should show county" do
    get :show, id: @county
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @county
    assert_response :success
  end

  test "should update county" do
    put :update, id: @county, county: { title: @county.title }
    assert_redirected_to county_path(assigns(:county))
  end

  test "should not destroy a county with teams" do
    assert_difference('County.count', 0) do
      delete :destroy, id: counties(:county_with_teams)
    end
    assert_redirected_to counties_path
  end
  test "should not destroy a county with people" do
    assert_difference('County.count', 0) do
      delete :destroy, id: counties(:county_with_people)
    end
    assert_redirected_to counties_path
  end
  test "should destroy an empty county" do
    assert_difference('County.count', -1) do
      delete :destroy, id: counties(:empty_county)
    end
    assert_redirected_to counties_path
  end
end
