require 'test_helper'

class CheatsheetTest < ActiveSupport::TestCase
  def setup
    @user = users(:janessa)
    body = %{
      # Rspec

      ### Setup
      To set up your project to use rspec:
      ```ruby
      rspec --init
      ```
      
      Navigate to the spec directory and create a new file with '_spec' appended to the file you're testing. 
      
      Create some tests in your spec file:
      ```ruby
      require ('./hello_world.rb')
      
      describe '#greet' do
      
        it 'greets with hello world' do
          expect(greet).to eq('hello, world!')
        end
        
      end
      ```
    }
    @cheatsheet = @user.cheatsheets.build(title: "Rspec Basics", topic: "rspec", 
                                 content: body)
  end

  test "should be valid" do
    assert @cheatsheet.valid?
  end

  test "should not be valid" do
    @cheatsheet.user_id = nil
    assert_not @cheatsheet.valid?
  end

  test "content should be present" do
    @cheatsheet.content = "     "
    assert_not @cheatsheet.valid?
  end

  test "topic should be present" do
    @cheatsheet.topic = "   "
    assert_not @cheatsheet.valid?
  end

  test "title should be present" do
    @cheatsheet.title = "          "
    assert_not @cheatsheet.valid?
  end
end
