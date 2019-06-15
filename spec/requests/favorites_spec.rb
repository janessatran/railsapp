require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  before do
    @user = create(:user)
    body = %{
      Test 
    }
    @cheatsheet = @user.cheatsheets.create(title: "Rspec Basics", topic: "rspec", 
                                 content: body, tag_list: "test")
    @other_user = create(:user)
    get login_path
    post login_path, params: { session: { email: @other_user.email,
                                          password: 'password123' } }
    @cheatsheet.favorites.create(user_id: @other_user.id)
  end
  
  describe "GET /favorites" do

    it "shows the favorites page of the logged in user" do
      expect(is_logged_in?).to eq(true)
      get favorites_user_path(@other_user)
      expect(@other_user.favorites.empty?).not_to eq(true)
      expect(response.body).to match(@other_user.favorites.count.to_s)
      @other_user.favorites.each do |fav|
        assert_select "a[href=?]", cheatsheet_path(fav.cheatsheet_id)
      end
    end
  end
end
