require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  before do
    @user = create(:user)
    get login_path
    post login_path, params: { session: { email: @user.email,
                                              password: 'password123' } } 
  end

  describe "GET /root" do
    it "lists feed_items if user is logged in" do

      @cheatsheet = @user.cheatsheets.create!(title: "Rspec Basics", topic: "rspec", 
                                             content: "Test!!", tag_list: "test", visibility: true)
      get root_url            

      @user.feed.where(visibility: true).each do |item|
        assert_select "a[href=?]", cheatsheet_path(item.id)
      end
    end
  end

  describe "GET /search" do
    it "redirects to root if not tag is passed in search bar" do
      get search_page_path()
      
      expect(response).to redirect_to(root_url)
    end

    it "lists cheatsheets that matches tag if tag is passed in search bar" do
      get search_page_path, params: { search: "test" }

      expect(response.body).to include("Search Result for tag")
    end
  end
end
