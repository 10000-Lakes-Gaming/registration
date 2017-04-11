require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    $disable_authentication = true
    @event                  = events(:my_event)
    @user                   = users(:admin)
    sign_in users(:admin)
  end

  teardown do
    $disable_authentication = false
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should create route to show" do
    assert_generates "/events/#{@event.id}",
                     {controller: 'events', action: 'show', id: @event.id}
  end

  test "should recognize route to show" do
    assert_recognizes({controller: 'events', action: 'show', id: "#{@event.id}"}, "/events/#{@event.id}")
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do

    assert_difference('Event.count') do
      post :create, event: {end: @event.end, location: @event.location, name: @event.name, start: @event.start}
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event
    assert_response :success
  end

  test "should update event" do
    patch :update, id: @event, event: {end: @event.end, location: @event.location, name: @event.name, start: @event.start}
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end
    assert_redirected_to events_path
  end
end
