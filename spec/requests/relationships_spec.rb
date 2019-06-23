require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  before do
    @user = create(:user)
    @other_user = create(:user)
    get login_path
    post login_path, params: { session: { email: @user.email, 
                                          password: 'password123' } }
  end

  describe "POST /relationships" do
    it "creates a relationship between users if one follows the other" do
      post relationships_path, params: { followed_id: @other_user.id }

      expect(@other_user.followers).to include(@user)
    end
  end

  describe "DELETE /relationship" do
    it "destroys a relationship between users if one unfollows the other" do
      post relationships_path, params: { followed_id: @other_user.id }
      relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
      delete relationship_path(relationship.id)

      expect(@other_user.followers).not_to include(@user)
    end
  end
end
