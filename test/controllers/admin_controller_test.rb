require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  setup do
    $disable_authentication = true
    sign_in users(:admin)
  end

  teardown do
    $disable_authentication = false
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
