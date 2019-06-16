require 'rails_helper'

RSpec.describe "Cheatsheets", type: :request do

  before do
    @user = create(:user)
    log_in_as(@user, password: 'password123', remember_me: '1')
  end

  describe "create cheatsheet" do
    it "create should work if user is logged in" do
      expect(is_logged_in?).to eq(true)
      initial_count = Cheatsheet.count
      expect do
        post cheatsheets_path, params: { cheatsheet: { title: 'title', 
                                                      tag_list: 'test', 
                                                      content: 'Lorem ipsum'}  }
      end.to change { Cheatsheet.count }.from(initial_count).to(initial_count + 1)                 
      expect(flash[:success]).to eq("Your cheatsheet has been created!")
    end

    it "should have a default private visibility if the checkbox is not checked" do
      visit cheatsheets_path
      within("#cheatsheet") do
        fill_in 'title', with: 'testing cheatsheet'
        fill_in 'content', with: 'This is a test.'
        fill_in 'tag_list', with: 'rspec-test'
        find(:css, "#visibility-checkbox").set(true)
 
      end
      click_button 'Sign in'
      expect(page).to have_content 'Success'
    end

    it 'redirects users to login for users who are not logged in' do
      delete logout_path #log out user
      expect(is_logged_in?).to eq(false)
      expect(response).to redirect_to(root_url)
      follow_redirect!
      get new_cheatsheet_path
      expect(response).to redirect_to(login_url)
    end
  end
end
