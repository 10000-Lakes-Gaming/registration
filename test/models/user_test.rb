require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @normal = users(:normal_guy)
  end


  test "User long name is name (email)" do
    test = "Master Admin (admin@mail.com)"
    assert_equal test, @admin.long_name
  end

  test "Normal guy is not admin" do
    assert_not @normal.admin?
  end

  test "Admin is an admin user" do
    assert @admin.admin?
  end

  test "New user without PFS # fails validation" do
    user = User.new(name: 'new guy')
    assert_not user.valid?
  end

  test "new user with PFS number passes validation" do
    user = User.new(name: 'Guy with PFS#', pfs_number: '9999999', email: 'guy@12345gmail.com', password: "thisisapassword")
    assert user.valid?
  end

  test "user vs nill sort is -1" do
    assert_equal -1, @admin <=> nil
  end

end
