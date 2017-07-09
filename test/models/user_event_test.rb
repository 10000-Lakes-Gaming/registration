require 'test_helper'

class UserEventTest < ActiveSupport::TestCase
  setup do
    @admin_my_event      = user_events(:admin_my_event)
    @normal_guy_my_event = user_events(:normal_guy_my_event)
    @admin_other_event   = user_events(:admin_other_event)
    @paid_event          = user_events(:paid_user_event)
    @admin               = users(:admin)
    @normal_guy          = users(:normal_guy)
    @my_event            = events(:my_event)

  end

  test 'Admin has his events and not others' do
    assert_includes @admin.user_events, @admin_my_event
    assert_includes @admin.user_events, @admin_other_event
    assert_not_includes @admin.user_events, @normal_guy_my_event
  end

  test 'Normal Guy has his event and not others' do
    assert_not_includes @normal_guy.user_events, @admin_my_event
    assert_not_includes @normal_guy.user_events, @admin_other_event
    assert_includes @normal_guy.user_events, @normal_guy_my_event
  end


  test 'sort normal is before admin (by name)' do
    assert_equal 1, @admin_my_event <=> @normal_guy_my_event
  end


  test 'sort normal is before nil' do
    assert_equal(-1, @normal_guy <=> nil)
  end

  test 'no game master list is safe' do
    assert_equal 0, @normal_guy_my_event.current_gming_count
    assert_equal [], @normal_guy_my_event.game_masters
    assert_not_equal nil, @normal_guy_my_event.game_masters
  end

  test 'not a gm' do
    assert_not @normal_guy_my_event.gamemaster?
  end

  test 'Name of registration is that of the event' do
    assert_equal @my_event.name, @normal_guy_my_event.name
  end

  test 'Total Payment for event with no premium tables equals event cost' do
    skip
    assert_equal @my_event.price, @paid_event.total_paid
  end

  test 'Total price equals price of event plus tables' do
    assert_equal 40, @paid_event.total_price
  end

  test 'Paid event, unpaid table, paid not equal price' do
    reg = user_events(:paid_event_unpaid_table)
    assert_not_equal reg.total_price, reg.total_paid
  end


end
