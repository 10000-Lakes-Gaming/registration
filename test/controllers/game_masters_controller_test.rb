require 'test_helper'

class GameMastersControllerTest < ActionController::TestCase
  setup do
    @game_master = game_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_master" do
    assert_difference('GameMaster.count') do
      post :create, game_master: { table_id: @game_master.table_id, user_event_id: @game_master.user_event_id }
    end

    assert_redirected_to game_master_path(assigns(:game_master))
  end

  test "should show game_master" do
    get :show, id: @game_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_master
    assert_response :success
  end

  test "should update game_master" do
    patch :update, id: @game_master, game_master: { table_id: @game_master.table_id, user_event_id: @game_master.user_event_id }
    assert_redirected_to game_master_path(assigns(:game_master))
  end

  test "should destroy game_master" do
    assert_difference('GameMaster.count', -1) do
      delete :destroy, id: @game_master
    end

    assert_redirected_to game_masters_path
  end
end
