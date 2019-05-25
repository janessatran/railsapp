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
                                                      topic: 'test', 
                                                      content: 'Lorem ipsum'}  }
      end.to change { Cheatsheet.count }.from(initial_count).to(initial_count + 1)                 
      expect(flash[:success]).to eq("Your cheatsheet has been created!")
    end

    it 'redirects users to login for users who are not logged in' do
      log_out if logged_in?
      get '/new'
      expect(response).to redirect_to(login_url)
    end
  end

end
