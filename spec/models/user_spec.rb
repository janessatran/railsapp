require 'rails_helper'

RSpec.describe User, type: :model do
  before :context do 
    @user = User.create!(name: "Example", email: "test4@example.com",
    password: "passexample", password_confirmation: "passexample" )
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

      @user.cheatsheets.create!(title: "Test Header", topic: "test", content: "Lorem ipsum")
      @user.cheatsheets.create!(title: "Test Header 2", topic: "test", content: "Lorem ipsum dos")
      
      initial_count = Cheatsheet.count

      @user.destroy

      final_count = Cheatsheeet.count

      expect(intial_count - 2).to eq(final_count)
    end
  end
end
