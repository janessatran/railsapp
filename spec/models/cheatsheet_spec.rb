require 'rails_helper'

RSpec.describe Cheatsheet, type: :model do

  before do
    @user = create(:user)
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
    @cheatsheet = @user.cheatsheets.create(title: "Rspec Basics", topic: "rspec", 
                                 content: body, tag_list: "test", visibility: false)
  end

  context 'When a new cheatsheet is created' do
    it 'should have a title, topic, content, and user to be valid' do
      expect(@cheatsheet).to be_valid
    end

    it 'should be invalid if the user_id is nil' do
      @cheatsheet.user_id = nil
      expect(@cheatsheet).not_to be_valid
    end

    it 'should have content' do
      @cheatsheet.content = "       "
      expect(@cheatsheet).not_to be_valid
    end

    it 'should have a title' do
      @cheatsheet.title = "      "
      expect(@cheatsheet).not_to be_valid
    end

    it 'should have default visibility set to false' do
      expect(@cheatsheet.visibility).to eq(false)
    end
  end

end
