require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  before do 
    @user = create(:user)
  end

  describe "GET /login" do
    it "works! (now write some real specs)" do
      get login_path
      expect(response).to have_http_status(200)
    end
  end

  describe "login with invalid information" do
    it "doesn't work and flashes and error message" do
      get login_path
      expect(response).to render_template('sessions/new')
      post login_path, params: { session: {email: "test@example.com" , password: "password" } }
      expect(response).to render_template('sessions/new')
      expect(flash[:danger]).not_to be_nil
      get root_path
      expect(flash[:alert]).to be_nil
    end
  end

  describe "login with valid information followed by logout" do
    it 'redirects the user to their profile' do
      get login_path
      post login_path, params: { session: { email: @user.email, 
                                            password: 'password123' } }
      expect(response).to redirect_to(@user)
      assert is_logged_in?
      follow_redirect!
      expect(response).to render_template('users/show')
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(@user)
      delete logout_path
      expect(is_logged_in?).to eq(false)
      expect(response).to redirect_to(root_url)
      delete logout_path # simulate a user clicking logout in a second window.
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(@user), count: 0
    end
  end

  describe "authenticated?" do
    it 'returns false for a user with nil digest' do
      expect(@user.authenticated?('')).to eq(false)
    end
  end

  describe "login with remembering" do
    it 'sets cookie to remember session' do
      log_in_as(@user, password: 'password123', remember_me: '1')
      expect(cookies[:remember_token]).not_to be_nil
    end
  end

  describe "login without remembering" do
    it "deletes the cookie" do
      # Log in to set the cookie.
      log_in_as(@user, remember_me: '1')
      # Log in again and verify that the cookie is deleted.
      log_in_as(@user, remember_me: '0')
      expect(cookies[:remember_token]).to be_nil
    end
  end



end
