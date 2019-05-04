require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
  end

  # test "should redirect to home when search bar empty" do
  #   search_param = ''
  #   params[:search] = search_param

  # end
end
