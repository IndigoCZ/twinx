require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup do
    @category = categories(:juniori)
  end

  test "should get index" do
    get :index, :race_id => Race.first.id
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should get new" do
    get :new, :race_id => Race.first.id
    assert_response :success
  end

  test "should create category" do
    assert_difference('Category.count') do
      post :create, :race_id => Race.first.id, category: { race_id: @category.race_id, title: @category.title }
    end

    assert_redirected_to race_category_path(@category.race_id, assigns(:category))
  end

  test "should show category" do
    get :show, id: @category, :race_id => Race.first.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @category, :race_id => Race.first.id
    assert_response :success
  end

  test "should update category" do
    put :update, id: @category, :race_id => Race.first.id, category: { race_id: @category.race_id, title: @category.title }
    assert_redirected_to race_category_path(@category.race_id, assigns(:category))
  end

  test "should destroy an empty category" do
    assert_difference('Category.count', -1) do
      delete :destroy, id: categories(:empty_category), :race_id => categories(:empty_category).race_id
    end

    assert_redirected_to race_categories_path(categories(:empty_category).race_id)
  end

  test "should not destroy a category with participants" do
    assert_difference('Category.count', 0) do
      delete :destroy, id: categories(:category_with_participants), :race_id => categories(:category_with_participants).race_id
    end

    assert_redirected_to race_categories_path(categories(:category_with_participants).race_id)
  end
end
