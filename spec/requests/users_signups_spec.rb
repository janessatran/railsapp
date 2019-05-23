require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /users_signups" do
    it "works! (now write some real specs)" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe "valid signup" do
    it "creates the new user and redirects to profile" do
      get signup_path
      initial_count = User.count
      expect do
        post users_path, params: { user: { name:  "Example User",
                                           email: "user@example.com",
                                           password:              "password",
                                           password_confirmation: "password" }, 
                                  session: { remember_me: '1'} }
      end.to change { User.count }.from(initial_count).to(initial_count + 1)
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(is_logged_in?).to eq(true)
    end
  end
end
