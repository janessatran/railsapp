require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = Topic.new(name: "Ruby")
  end
  
  test "name should be present" do
    @topic.name = "     "
    assert_not @topic.valid?
  end
end
