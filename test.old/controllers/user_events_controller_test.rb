require 'test_helper'

class UserEventsControllerTest < ActionController::TestCase
  setup do
    skip("Not ready to test")
    @user_event = user_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_event" do
    assert_difference('UserEvent.count') do
      post :create, user_event: { event_id: @user_event.event_id, paid: @user_event.paid, user_id: @user_event.user_id }
    end

    assert_redirected_to user_event_path(assigns(:user_event))
  end

  test "should show user_event" do
    get :show, id: @user_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_event
    assert_response :success
  end

  test "should update user_event" do
    patch :update, id: @user_event, user_event: { event_id: @user_event.event_id, paid: @user_event.paid, user_id: @user_event.user_id }
    assert_redirected_to user_event_path(assigns(:user_event))
  end

  test "should destroy user_event" do
    assert_difference('UserEvent.count', -1) do
      delete :destroy, id: @user_event
    end

    assert_redirected_to user_events_path
  end
end
