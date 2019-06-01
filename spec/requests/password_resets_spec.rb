require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do

  before do
    @user = create(:user)
  end

  describe "GET /password_resets" do
    it "sends a token to the user to reset the password" do
      get new_password_reset_path
      expect(response).to render_template('password_resets/new')

      # Invalid email.
      post password_resets_path, params: { password_reset: { email: "" }}
      expect(flash).not_to be_empty
      expect(response).to render_template('password_resets/new')

      # Valid email.
      post password_resets_path, params: { password_reset: { email: @user.email }}
      expect(@user.reset_digest).not_to eq(@user.reload.reset_digest)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(flash).not_to be_empty
      expect(response).to redirect_to(root_url)

      # Password reset form
      @user = assigns(:user)
      # Wrong email
      get edit_password_reset_path(@user.reset_token, email: "")
      expect(response).to redirect_to(root_url)
      # Inactive user
      @user.toggle!(:activated)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to(root_url)
      @user.toggle!(:activated)

      # Right email, wrong token
      get edit_password_reset_path('wrong token', email: @user.email)
      expect(response).to redirect_to(root_url)

      # Right email, right token
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to render_template('password_resets/edit')
      assert_select "input[name=email][type=hidden][value=?]", @user.email

      # Invalid password and confirmation
      patch password_reset_path(@user.reset_token), params: { email: @user.email, 
                                                               user: { password: 'foobaz',
                                                                       password_confirmation: 'barquux'  
                                                                      }
                                                              }
      assert_select 'div#error_explanation'

      # Empty password
      patch password_reset_path(@user.reset_token), params: { email: @user.email, 
                                                              user: { password: "", password_confirmation: ""} }
      assert_select 'div#error_explanation'

      # Valid password and confirmation
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: 'foobaz', 
                                                                      password_confirmation: 'foobaz' } }
      expect(is_logged_in?).to eq(true)
      expect(flash).not_to be_empty
      expect(response).to redirect_to(@user)
    end
  end

  describe "password reset token" do
    it "expires after 3 hours" do
      get new_password_reset_path
      post password_resets_path, params: { password_reset: { email: @user.email } }
      @user = assigns(:user)
      @user.update_attribute(:reset_sent_at, 3.hours.ago)
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: "foobar", 
                                                                      password_confirmation: "foobar" } }
      assert_response :redirect
      follow_redirect!
      expect(response.body).to match(/expired/i)
    end
  end
end
