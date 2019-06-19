require 'rails_helper'

RSpec.describe "Cheatsheets", type: :request do

  before do
    @user = create(:user)
    @other_user = create(:user)
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

    it 'redirects users to login for users who are not logged in' do
      delete logout_path #log out user
      expect(is_logged_in?).to eq(false)
      expect(response).to redirect_to(root_url)
      follow_redirect!
      get new_cheatsheet_path
      expect(response).to redirect_to(login_url)
    end
  end

  describe 'show cheatsheet' do
    context 'if the visibility of the cheatsheet is private' do 

      it 'should not be visible to users who are not the original author' do
        @cheatsheet = @user.cheatsheets.create(title: "This is a visibility test", 
          content: "Testing", tag_list: "test", visibility: false)

        delete logout_path #log out user
        follow_redirect!
        log_in_as(@other_user, password: 'password123', remember_me: '1')

        get cheatsheet_path(@cheatsheet)

        expect(response.code).to eq('302')
        expect(response).to redirect_to(root_url)
      end

      it 'should be visible to the user who is the original author' do
        @cheatsheet = @user.cheatsheets.create(title: "This is a visibility test", 
          content: "Testing", tag_list: "test", visibility: false)

        get cheatsheet_path(@cheatsheet)

        expect(response.code).to eq('200')
        expect(response.body).to include("This is a visibility test")
      end
    end
  end
end
