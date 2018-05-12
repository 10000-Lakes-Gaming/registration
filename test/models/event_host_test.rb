require 'test_helper'

class EventHostTest < ActiveSupport::TestCase

  setup do
    @one    = event_hosts(:one)
    @two    = event_hosts(:two)
    @no_end = event_hosts(:no_end)
  end

  test "host one has end date" do
    assert @one.end_date?
  end

  test "host no_end has no end date" do
    assert_not @no_end.end_date?
  end

  test "host one is active!" do
    assert @one.active?
  end

  test "host two is NOT active!" do
    assert_not @two.active?
  end

  test "host no_end is NOT active!" do
    assert @no_end.active?
  end

  test "host one active tomorrow" do
    assert @one.active? Date.tomorrow
  end

  test "host two active yesterday" do
    assert @two.active? Date.yesterday
  end

  test "host two not active 10 days ago" do
    assert_not @two.active? Date.today - 10
  end

  test "no end active next year!" do
    assert @no_end.active? Date.today + 365
  end

end
