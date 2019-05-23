require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
    before do
        @user = create(:user)
    end

    describe "GET /users" do
        it "should redirect index when not logged in" do
            log_out if is_logged_in?
            get :index
            expect(response).to redirect_to(login_url)
        end
    end

   
end
