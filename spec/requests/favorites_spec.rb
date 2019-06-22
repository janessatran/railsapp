require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  before do
    @user = create(:user)
    @cheatsheet = @user.cheatsheets.create(title: "Rspec Basics", topic: "rspec", 
                                 content: "Test!!", tag_list: "test", visibility: true)
    @other_user = create(:user)

    get login_path

    post login_path, params: { session: { email: @other_user.email,
                                          password: 'password123' } }

    post favorites_path, params: { cheatsheet_id: @cheatsheet.id, user_id: @user.id }
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

  describe "remove favorite" do

    it "decreases the favorite count for each unfavorite" do
      initial_count = @cheatsheet.favorites.count
      fav = @other_user.favorites.find_by(cheatsheet_id: @cheatsheet.id)

      expect do
        delete favorite_path(fav), params: { cheatsheet_id: @cheatsheet.id, user_id: @other_user.id }
      end.to change  {  @cheatsheet.favorites.count }.from(initial_count).to(initial_count - 1)
    end
  end
end
