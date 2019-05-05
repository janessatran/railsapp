require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Janessa", email: "janessa@example.com",
                     password: "password", password_confirmation: "password" )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "name should be 500 characters or less" do
    @user.name = 'a'*501
    assert_not @user.valid?
  end

  test "email should be 255 characters or less" do
    @user.email = 'a'*250 + "@example.com"
    assert_not @user.valid?
  end

  test "emails should be saved as lowercase" do
    test_email = "JaNeSsA_HeLLo@EmAiL.CoM"
    @user.email = test_email
    @user.save
    assert_equal test_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
