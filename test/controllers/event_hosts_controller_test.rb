require 'test_helper'

class EventHostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_host = event_hosts(:one)
  end

  # TODO - fix these for the correct routes

  # test "should get index" do
  #   get event_hosts_url
  #   assert_response :success
  # end
  #
  # test "should get new" do
  #   get new_event_host_url
  #   assert_response :success
  # end
  #
  # test "should create event_host" do
  #   assert_difference('EventHost.count') do
  #     post event_hosts_url, params: { event_host: { end_date: @event_host.end_date, event_id: @event_host.event_id, start_date: @event_host.start_date, user_id: @event_host.user_id } }
  #   end
  #
  #   assert_redirected_to event_host_url(EventHost.last)
  # end

  # test "should show event_host" do
  #   get event_host_url(@event_host)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_event_host_url(@event_host)
  #   assert_response :success
  # end
  #
  # test "should update event_host" do
  #   patch event_host_url(@event_host), params: { event_host: { end_date: @event_host.end_date, event_id: @event_host.event_id, start_date: @event_host.start_date, user_id: @event_host.user_id } }
  #   assert_redirected_to event_host_url(@event_host)
  # end
  #
  # test "should destroy event_host" do
  #   assert_difference('EventHost.count', -1) do
  #     delete event_host_url(@event_host)
  #   end
  #
  #   assert_redirected_to event_hosts_url
  # end
end
