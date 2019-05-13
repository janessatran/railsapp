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
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(@user), count: 0
    end
  end


end
