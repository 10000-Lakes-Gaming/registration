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
    @empty_reg_tables    = user_events(:empty_registration_tables)
  end


  test "@empty_reg_tables  has no table signups!" do
    assert @empty_reg_tables.no_signups?
  end

  test "@paid_event has  table signups!" do
    assert_not @paid_event.no_signups?
  end

  test 'User event has no registrations' do
    # puts "#{@empty_reg_tables.user.name} is signed up for: " + @empty_reg_tables.registration_tables
    assert_empty @empty_reg_tables.registration_tables
    assert @empty_reg_tables.registration_tables.empty?
  end

  test 'User event HAS registations'do
    assert_not_empty @paid_event.registration_tables
    assert_not @paid_event.registration_tables.empty?
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

  test 'Unpaid additional payment returns true' do
    reg = user_events(:paid_user_event_unpaid_additional)
    assert reg.unpaid_additional_payments?
  end


  test 'Paid additional payment returns false' do
    reg = user_events(:normal_guy_my_event)
    assert_not reg.unpaid_additional_payments?
  end

end
