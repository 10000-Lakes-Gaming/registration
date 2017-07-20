require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @my_event    = events(:my_event)
    @other_event = events(:other)
  end


  test "Can load My Event!" do
    assert @my_event.name == 'My Event'
  end

  test "Can load other event" do
    assert @other_event
  end

  test "RSVPs are closed on my event" do
    @my_event.rsvp_close = 1.day.ago
    assert @my_event.closed?
  end

  test "RSVPs are OPEN on other event" do
    assert_not @other_event.closed?
  end

  test "Events are not the same!" do
    assert_not_equal @my_event, @other_event
  end

  test "The same event is  the same!" do
    event = events(:my_event)
    assert_equal @my_event, event
  end

  test "Events sort by name, and my event comes before other." do
    assert (@my_event <=> @other_event) < 0
  end

  test "My event has 4 registrations, including the admin user's" do
    admin_user_event = user_events(:admin_my_event)

    assert_equal 4, @my_event.user_events.size
    assert_includes @my_event.user_events, admin_user_event

  end

  test 'Event price is as expected' do
    assert_equal 20, @my_event.price
  end

  test 'I have premium tables' do
    assert_not_empty @my_event.premium_tables
  end

  test 'I have 2 premium tables' do
    assert_equal 2, @my_event.premium_tables.length
  end

  test "premium table is in my_event" do
    premium_table  = tables(:premium)
    premium_tables = @my_event.premium_tables
    assert premium_tables.include? premium_table
  end

  test 'prereg is closed' do
    @my_event.prereg_ends = 5.days.ago
    assert @my_event.prereg_closed?
  end

  test 'With prereg closed, price is onsite' do
    @my_event.prereg_ends = 5.days.ago
    assert_equal 30, @my_event.price
  end

  test 'This event has an early bird' do
    assert @my_event.early_bird?
  end


  test 'This event doesn\'t have an early bird' do
    assert_not @other_event.early_bird?
  end

end
