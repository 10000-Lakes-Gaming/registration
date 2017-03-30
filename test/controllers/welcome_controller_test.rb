require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    skip("Not ready to test")
    sign_in Users(:one)
    get :index
    assert_response :success
  end

end
