require 'test_helper'

class TablesControllerTest < ActionController::TestCase
  setup do
    skip("Not ready to test")
    @table = tables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create table" do
    assert_difference('Table.count') do
      post :create, table: { max_players: @table.max_players, scenario_id: @table.scenario_id, session_id: @table.session_id }
    end

    assert_redirected_to table_path(assigns(:table))
  end

  test "should show table" do
    get :show, id: @table
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @table
    assert_response :success
  end

  test "should update table" do
    patch :update, id: @table, table: { max_players: @table.max_players, scenario_id: @table.scenario_id, session_id: @table.session_id }
    assert_redirected_to table_path(assigns(:table))
  end

  test "should destroy table" do
    assert_difference('Table.count', -1) do
      delete :destroy, id: @table
    end

    assert_redirected_to tables_path
  end
end
