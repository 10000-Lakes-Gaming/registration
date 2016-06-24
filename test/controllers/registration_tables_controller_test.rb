require 'test_helper'

class RegistrationTablesControllerTest < ActionController::TestCase
  setup do
    @registration_table = registration_tables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_tables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_table" do
    assert_difference('RegistrationTable.count') do
      post :create, registration_table: { registration: @registration_table.registration, table: @registration_table.table }
    end

    assert_redirected_to registration_table_path(assigns(:registration_table))
  end

  test "should show registration_table" do
    get :show, id: @registration_table
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration_table
    assert_response :success
  end

  test "should update registration_table" do
    patch :update, id: @registration_table, registration_table: { registration: @registration_table.registration, table: @registration_table.table }
    assert_redirected_to registration_table_path(assigns(:registration_table))
  end

  test "should destroy registration_table" do
    assert_difference('RegistrationTable.count', -1) do
      delete :destroy, id: @registration_table
    end

    assert_redirected_to registration_tables_path
  end
end
