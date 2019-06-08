require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @relationship = Relationship.new(follower_id: create(:user).id,
                                     followed_id: create(:user).id)
  end

  it "should be valid" do
    expect(@relationship).to be_valid
  end

  it "should require a followed_id" do
    @relationship.follower_id = nil
    expect(@relationship.valid?).not_to eq(true)
  end

  it "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship.valid?).not_to eq(true)
  end
end
