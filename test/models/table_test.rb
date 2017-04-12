require 'test_helper'

class TableTest < ActiveSupport::TestCase
  setup do
    @morning           = sessions(:morning)
    @evening           = sessions(:evening)
    @my_event          = events(:my_event)
    @table_one         = tables(:one)
    @table_two         = tables(:two)
    @scenario_one_five = scenarios(:scenario_one_five)
  end

  test "table one is in morning session" do
    assert_equal @morning, @table_one.session
  end

  test "table two is in morning session" do
    assert_equal @morning, @table_two.session
  end

  test "cannot save table without session" do
    table             = Table.new
    table.scenario    = @scenario_one_five
    table.max_players = 6
    table.gms_needed  = 2
    assert_not table.save
  end

  test "cannot save table without scenario" do
    table             = Table.new
    table.session     = @morning
    table.max_players = 6
    table.gms_needed  = 2
    assert_not table.save
  end

  test "cannot save table without max players" do
    table            = Table.new
    table.session    = @morning
    table.scenario   = @scenario_one_five
    table.gms_needed = 2
    assert_not table.save
  end
  test "cannot save table without gms_needed" do
    table             = Table.new
    table.session     = @morning
    table.scenario    = @scenario_one_five
    table.max_players = 6
    assert_not table.save
  end

  test "Can save if we set a session, scenario, and max_players, and min_GMs into the table" do
    table             = Table.new
    table.session     = @morning
    table.scenario    = @scenario_one_five
    table.max_players = 12
    table.gms_needed  = 2

    assert table.save, "Cannot save the table"
  end

  test "Table One has scenario 1-5" do
    assert_equal @scenario_one_five, @table_one.scenario
  end

  test "Table One has 4 seats available" do
    @table_one.stub(:current_registrations, 4) do
      assert_equal 4,@table_one.current_registrations
    end
  end


end
