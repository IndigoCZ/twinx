require 'test_helper'

class ParticipantsControllerTest < ActionController::TestCase
  setup do
    @participant = participants(:sampion)
    @person = people(:sampion)
  end

  test "should get index" do
    get :index, :race_id => Race.first.id
    assert_response :success
    assert_not_nil assigns(:participants)
  end

  test "should get new" do
    get :new, :race_id => Race.first.id
    assert_not_nil assigns(:person)
    assert_not_nil assigns(:participant)
    assert_response :success
  end
  test "should create participant" do
    @person = people(:participant_create)
    @participant = participants(:participant_create)
    assert_difference('Participant.count') do
      post :create, :race_id => Race.first.id, person: {
        first_name:@person.first_name,
        last_name:@person.last_name,
        yob:@person.yob,
        sex:@person.sex
      }, participant: {
        starting_no: @participant.starting_no,
        category_id: @participant.category.id
      }, county: {
        title:@person.county.title
      }
    end

    assert_redirected_to race_participants_path(assigns(:current_race))
  end
end
=begin
require 'test_helper'

class RacesControllerTest < ActionController::TestCase
  setup do
    @race = races(:upcoming_race)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:races)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create race" do
    assert_difference('Race.count') do
      post :create, race: { held_on: @race.held_on, title: @race.title }
    end

    assert_redirected_to race_path(assigns(:race))
  end

  test "should show race" do
    get :show, id: @race
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @race
    assert_response :success
  end

  test "should update race" do
    put :update, id: @race, race: { held_on: @race.held_on, title: @race.title }
    assert_redirected_to race_path(assigns(:race))
  end

  test "should not destroy a race with teams" do
    assert_difference('Race.count', 0) do
      delete :destroy, id: races(:race_with_teams)
    end

    assert_redirected_to races_path
  end
  test "should not destroy a race with categories" do
    assert_difference('Race.count', 0) do
      delete :destroy, id: races(:race_with_categories)
    end

    assert_redirected_to races_path
  end
  test "should destroy an empty race" do
    assert_difference('Race.count', -1) do
      delete :destroy, id: races(:empty_race)
    end

    assert_redirected_to races_path
  end
end
=end
