require 'rails_helper'

RSpec.describe "UsersIndices", type: :request do
  
  before do
    @user = create(:user)
    create_list(:user, 40)
  end

  describe "GET /index" do
    it "shows the index page with pagination" do
      log_in_as(@user, password: 'password123', remember_me: '1')
      get users_path
      
      expect(response).to render_template('users/index')
      assert_select "div.pagination"
      User.paginate(page: 1).each do |user|
        assert_select 'a[href=?]', user_path(@user), text: @user.name
      end
    end
  end
end
