require 'test_helper'

class ScenariosControllerTest < ActionController::TestCase
  setup do
    skip("Not ready to test")
    @scenario = scenarios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scenarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scenario" do
    assert_difference('Scenario.count') do
      post :create, scenario: { author: @scenario.author, description: @scenario.description, hard_mode: @scenario.hard_mode, name: @scenario.name, paizo_url: @scenario.paizo_url, scenario_number: @scenario.scenario_number, season: @scenario.season, type: @scenario.type }
    end

    assert_redirected_to scenario_path(assigns(:scenario))
  end

  test "should show scenario" do
    get :show, id: @scenario
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scenario
    assert_response :success
  end

  test "should update scenario" do
    patch :update, id: @scenario, scenario: { author: @scenario.author, description: @scenario.description, hard_mode: @scenario.hard_mode, name: @scenario.name, paizo_url: @scenario.paizo_url, scenario_number: @scenario.scenario_number, season: @scenario.season, type: @scenario.type }
    assert_redirected_to scenario_path(assigns(:scenario))
  end

  test "should destroy scenario" do
    assert_difference('Scenario.count', -1) do
      delete :destroy, id: @scenario
    end

    assert_redirected_to scenarios_path
  end
end
