require 'test_helper'

class CheatsheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cheatsheets_new_url
    assert_response :success
  end

end
