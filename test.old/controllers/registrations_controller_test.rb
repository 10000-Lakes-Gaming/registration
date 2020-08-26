require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    skip("Not ready to test")
    @user_event = registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration" do
    assert_difference('Registration.count') do
      post :create, user_event: {event_id: @user_event.event_id, paid: @user_event.paid, user_id: @user_event.user_id }
    end

    assert_redirected_to registration_path(assigns(:user_event))
  end

  test "should show registration" do
    get :show, id: @user_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_event
    assert_response :success
  end

  test "should update registration" do
    patch :update, id: @user_event, user_event: {event_id: @user_event.event_id, paid: @user_event.paid, user_id: @user_event.user_id }
    assert_redirected_to registration_path(assigns(:user_event))
  end

  test "should destroy registration" do
    assert_difference('Registration.count', -1) do
      delete :destroy, id: @user_event
    end

    assert_redirected_to registrations_path
  end
end
