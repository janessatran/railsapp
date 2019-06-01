require 'rails_helper'

RSpec.describe "Users Edits", type: :request do

  before do
    @user = create(:user) 
    @alt_user = create(:user) 
    @admin_user = create(:admin_user)
    create_list(:user, 40)
  end    

  describe "GET /users_edits" do
    it "works! (now write some real specs)" do
      log_in_as(@user, password: 'password123', remember_me: '1')
      get edit_user_path(@user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe "unsuccessful edit" do
    it "should not update if the name field is blank" do
      log_in_as(@user, password: 'password123', remember_me: '1')
      get edit_user_path(@user.id)
      expect(response).to render_template('users/edit')
      patch user_path(@user), params: { user: { name:  "",
                                              email: "test@user.com",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
      expect(response).to render_template('users/edit')
    end

    it "should raise error message 'First name cant be blank' if name left blank" do
      log_in_as(@user, password: 'password123', remember_me: '1')
      get edit_user_path(@user.id)
      expect(response).to render_template('users/edit')
      patch user_path(@user), params: { user: { name:  "   ",
                                              email: "phoebetester@user.com",
                                              password:              "password",
                                              password_confirmation: "password" } }
      assert_select 'div.alert.alert-danger',  'The form contains 1 error.'
    end

    it "should redirect edit when logged in as wrong user" do
      log_in_as(@alt_user, password: "password123")
      get edit_user_path(@user)
      expect(flash[:alert]).to be_nil
      expect(response).to redirect_to(root_url)
    end

    it "should redirect update when logged in as wrong user" do
      log_in_as(@alt_user, password: 'password123')
      patch user_path(@user), params: { user: { name:  "   ",
                                              password:              "password",
                                              password_confirmation: "password" } }
      expect(response).to redirect_to(root_url)
    end
  end

  describe "successful edit with friendly forwarding" do
    it "should reload the form with new information" do 
      get edit_user_path(@user.id)
      log_in_as(@user, password: 'password123', remember_me: '1')
      expect(response).to redirect_to(edit_user_path(@user.id))
      name = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(@user), params: { user: { name: name,
                                                email: email,
                                                password:    "",
                                                password_confirmation: "" } }
      expect(flash[:success]).to eq("Profile updated")
      @user.reload
      expect(@user.name).to eq(name)
      expect(@user.email).to eq(email)
    end
  end

  describe "admin rights" do
    it "should not be editable via web" do
        log_in_as(@user, password: @user.password, remember_me: '1')
        patch user_path(@user), params: { user: { password: @user.password, 
                                                 password_confirmation: @user.password, 
                                                 admin: true}}
        expect(@user.reload.admin?).to eq(false)
    end
  end

  describe "user account deletion" do
    it "should redirect destroy when not logged in" do
      expect { delete user_path(@user) }.not_to change(User, :count)
      expect(response).to redirect_to(login_url)
    end
  
    it "should redirect destroy when logged in as a non-admin" do
      log_in_as(@alt_user)
      expect { delete user_path(@user) }.not_to change(User, :count)
      expect(response).to redirect_to(login_url)
    end

    it "should display index as admin including pagination and delete links" do
      log_in_as(@admin_user, password: 'password123', remember_me: '1')
      expect(@admin_user.admin?).to eq(true)
      get users_path
      expect(response).to render_template('users/index')
      assert_select "div.pagination"
      first_page_of_users = User.paginate(page: 1)
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(@user), text: @user.name
        unless @user == @admin_user
          assert_select 'a[href=?]', user_path(@user), text: 'delete'
        end
      end
      initial_count = User.count
      expect { delete user_path(@alt_user) }.to change { User.count }.from(initial_count).to(initial_count - 1)
    end

    it "should display an index as a non-admin" do
      log_in_as(@user)
      get users_path
      assert_select 'a', text: 'delete', count: 0
    end
  end
end
