require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  setup do
    @morning     = sessions(:morning)
    @evening     = sessions(:evening)
    @my_event    = events(:my_event)
    @other_event = events(:other)
  end

  test "morning session should be in my event" do
    assert_equal @my_event, @morning.event
  end

  test "evening session should be in my event" do
    assert_equal @my_event, @evening.event
  end

  test "morning session should be in my event's session list " do
    assert_includes @my_event.sessions, @morning
  end

  test "evening session should be in my event's session list" do
    assert_includes @my_event.sessions, @evening
  end

  test "evening sessions should NOT be in other event's session list" do
    assert_not_includes @other_event.sessions, @evening
  end

end
