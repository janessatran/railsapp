require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  before do
    @user = create(:user)
    remember(@user)
  end

  describe 'remember user session based on token' do
    it 'returns correct user when session is nil' do
        expect(@user).to eq(current_user)
    end

    it 'returns nil when remember digest is wrong' do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to eq(nil)
    end
end
end
