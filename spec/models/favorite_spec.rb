require 'rails_helper'

RSpec.describe Favorite, type: :model do
  before do
    @user = create(:user)
    body = %{
      # Rspec
      Test 
    }
    @cheatsheet = @user.cheatsheets.create(title: "Rspec Basics", topic: "rspec", 
                                 content: body, tag_list: "test")
    @other_user = create(:user)
    @favorite = Favorite.new(cheatsheet_id: @cheatsheet.id, user_id: @other_user.id)
  end

  it "should be valid" do
    expect(@favorite).to be_valid
  end

  it "should require a cheatsheet_id" do
    @favorite.cheatsheet_id = nil
    expect(@favorite.valid?).not_to eq(true)
  end

  it "should require a user_id" do
    @favorite.user_id = nil
    expect(@favorite.valid?).not_to eq(true)
  end
end
