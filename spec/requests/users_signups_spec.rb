require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "GET /users_signups" do
    it "works! (now write some real specs)" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  describe "valid signup information with account activation" do
    it "creates the new user and redirects to profile" do
      get signup_path
      initial_count = User.count
      post users_path, params: { user: { name:  "Example User",
                                           email: "user@example.com",
                                           password:              "password",
                                           password_confirmation: "password" } }
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      @user = assigns(:user)
      expect(@user.activated?).to eq(false)
      # Try to log in before activation.
      log_in_as(@user)
      expect(is_logged_in?).to eq(false)
      # Invalid activation token
      get edit_account_activation_path("invalid token", email: @user.email)
      expect(is_logged_in?).to eq(false)
      # Valid token, wrong email
      get edit_account_activation_path(@user.activation_token, email: 'wrong')
      expect(is_logged_in?).to eq(false)
      # Valid activation token
      get edit_account_activation_path(@user.activation_token, email: @user.email)
      expect(@user.reload.activated?).to eq(true)
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(is_logged_in?).to eq(true)
      assert_template 'users/show'
    end
  end
end
