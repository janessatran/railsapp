require 'rails_helper'

RSpec.describe User, type: :model do
  before do 
    @user = create(:user)
    @other_user = create(:user)
  end

  context "relationships" do
    it "should follow and unfollow a user" do
      expect(@user.following?(@other_user)).not_to eq(true)
      @other_user.follow(@user)
      expect(@other_user.following?(@user)).to eq(true)
      expect(@user.followers.include?(@other_user)).to eq(true)
      @other_user.unfollow(@user)
      expect(@other_user.following?(@user)).not_to eq(true)
    end
  end

  context 'When a new user is created' do
    it 'should have a name, unique email, and matching password + password confirmations' do
      expect(@user).to be_valid
    end

    it 'should have non-blank name' do
      @user.name = "    "
      expect(@user).not_to be_valid
    end

    it 'should have a unique email address' do
      dup_user = @user.dup
      dup_user.email = @user.email.upcase
      @user.save
      expect(dup_user).not_to be_valid
    end

    it 'should have a name with 500 characters or less' do
      @user.name = 'x'*501
      expect(@user).not_to be_valid
    end

    it 'should have an email with 255 characters or less' do
      @user.email = 'x'*250 + '@example.com'
      expect(@user).not_to be_valid
    end

    it 'should have emails converted to lowercase upon saving' do
      test_email = "JaNeSsA_HeLLo@EmAiL.CoM"
      @user.email = test_email
      @user.save
      expect(test_email.downcase).to eq(@user.reload.email)
    end

    it 'should have a password at least 6 characters long' do
      @user.password = @user.password_confirmation = "a" * 6
      expect(@user).to be_valid
    end

    it 'should have associated cheatsheets destroyed when it is destroyed' do
      @user.save
      @user.cheatsheets.create!(title: "Test Header", tag_list: "test", content: "Lorem ipsum")
      @user.cheatsheets.create!(title: "Test Header 2", tag_list: "test", content: "Lorem ipsum dos")
      @user.save

      expect do
         @user.destroy
      end.to change { Cheatsheet.count }.from(Cheatsheet.count).to(Cheatsheet.count - 2)
    end
  end
end
