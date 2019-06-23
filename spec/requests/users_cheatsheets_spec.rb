require 'rails_helper'

RSpec.describe "Users Cheatsheets", type: :request do

  before do
    @user = create(:user) 
    @alt_user = create(:user) 
    @admin_user = create(:admin_user)
    create_list(:user, 40)
    50.times do
        title = Faker::Lorem.sentence(1)
        tag_list = "test, test2"
        content = Faker::Lorem.sentence(4)
        @user.cheatsheets.create!(title: title, content: content, tag_list: tag_list, visibility: true) 
        @user.cheatsheets.create!(title: title + "private", content: content, tag_list: tag_list, visibility: false)
    end
  end    

  describe "GET private_cheatsheets" do
    it "works if correct user is logged in" do
      log_in_as(@user, password: 'password123', remember_me: '1')
      get private_cheatsheets_user_path(@user)

      @user.cheatsheets.where(visibility: false).each do |cs|
        assert_select "a[href=?]", cheatsheet_path(cs)
      end
    end

    it "redirects user if not correct user" do
      get private_cheatsheets_user_path(@user)

      expect(response).to redirect_to(root_url)
    end
  end

  describe "GET public_cheatsheets" do
    it "shows public cheatsheets of user" do
      log_in_as(@user, password: 'password123', remember_me: '1')
      get public_cheatsheets_user_path(@user)
      
      @user.cheatsheets.where(visibility: true).each do |cs|
        assert_select "a[href=?]", cheatsheet_path(cs)
      end
    end

    it "does not redirect user if not logged in" do
      get public_cheatsheets_user_path(@user)

      expect(response.code).to eq('200')
      @user.cheatsheets.where(visibility: true).each do |cs|
        assert_select "a[href=?]", cheatsheet_path(cs)
      end
    end
  end

end