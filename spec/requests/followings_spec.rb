require 'rails_helper'

RSpec.describe "Followings", type: :request do
  before do
    @user = create(:user)
    @other_user = create(:user)
    get login_path
    post login_path, params: { session: { email: @user.email, 
                                          password: 'password123' } }
    @user.follow(@other_user)
    @other_user.follow(@user)

  end

  describe "GET /followings" do

    it " shows the following page" do
      expect(is_logged_in?).to eq(true)
      get following_user_path(@user)
      expect(@user.following.empty?).not_to eq(true)
      expect(response.body).to match(@user.following.count.to_s)
      @user.following.each do |user|
        assert_select "a[href=?]", user_path(@user)
      end
    end

    it "shows the followers page" do
      expect(is_logged_in?).to eq(true)
      get followers_user_path(@user)
      expect(@user.followers.empty?).not_to eq(true)
      expect(response.body).to match(@user.followers.count.to_s)
      @user.following.each do |user|
        assert_select "a[href=?]", user_path(@user)
      end
    end
  end
end
