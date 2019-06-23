require 'rails_helper'

RSpec.describe "Cheatsheets", type: :request do

  before do
    @user = create(:user)
    @other_user = create(:user)
    log_in_as(@user, password: 'password123', remember_me: '1')

    10.times do
      title = Faker::Lorem.sentence(1)
      tag_list = "test, test2"
      content = Faker::Lorem.sentence(4)
      @user.cheatsheets.create!(title: title, content: content, tag_list: tag_list, visibility: true) 
      @user.cheatsheets.create!(title: title + "private", content: content, tag_list: tag_list, visibility: false)
    end
  end

  describe "new" do
    it 'redirects users to login for users who are not logged in' do
      delete logout_path #log out user
      get new_cheatsheet_path

      expect(response).to redirect_to(login_url)
    end

    it 'instantiates new Cheatsheet if logged in' do
      get new_cheatsheet_path

      expect(assigns(:cheatsheet)).to be_a(Cheatsheet)
    end
  end

  describe "create" do
    it "create should work if user is logged in" do
      expect(is_logged_in?).to eq(true)
      initial_count = Cheatsheet.count

      expect do
        post cheatsheets_path, params: { cheatsheet: { title: 'title', 
                                                      tag_list: 'test', 
                                                      content: 'Lorem ipsum', 
                                                      visibility: 'true'}  }
      end.to change { Cheatsheet.count }.from(initial_count).to(initial_count + 1)   

      expect(flash[:success]).to eq("Your cheatsheet has been created!")
    end

    it 'creates an error message if the required fields are not filled out' do
      post cheatsheets_path, params: { cheatsheet: { title: '', 
        tag_list: '', 
        content: '', 
        visibility: 'true'}  }

      expect(flash[:danger]).to eq("Your cheatsheet is missing required values!")
    end
  end

  describe 'index' do
    it 'shows all cheatsheets that have visibility as true' do
      # for i in 1..10 do
      #   if i < 5
      #     post cheatsheets_path, params: { cheatsheet: { title: 'This is visible', 
      #       tag_list: 'test', 
      #       content: 'Lorem ipsum', 
      #       visibility: 'true'}  }
      #   else
      #     post cheatsheets_path, params: { cheatsheet: { title: 'This is not visible', 
      #       tag_list: 'test', 
      #       content: 'Lorem ipsum', 
      #       visibility: 'false'}  }
      #   end
      # end
      get cheatsheets_path

      expect(response.body).not_to include("This is not visible")
    end
  end

  describe 'show' do
    context 'if the visibility of the cheatsheet is private' do 

      it 'should not be visible to users who are not the original author' do
        @cheatsheet = @user.cheatsheets.create(title: "This is a visibility test", 
          content: "Testing", tag_list: "test", visibility: false)

        delete logout_path #log out user
        follow_redirect!
        log_in_as(@other_user, password: 'password123', remember_me: '1')

        get cheatsheet_path(@cheatsheet)

        expect(response.code).to eq('302')
        expect(response).to redirect_to(root_url)
      end

      it 'should be visible to the user who is the original author' do
        @cheatsheet = @user.cheatsheets.create(title: "This is a visibility test", 
          content: "Testing", tag_list: "test", visibility: false)

        get cheatsheet_path(@cheatsheet)

        expect(response.code).to eq('200')
        expect(response.body).to include("This is a visibility test")
      end
    end
  end
  
  describe "destroy" do
    it 'should redirect destroy when not logged in' do
      @cheatsheet = @user.cheatsheets[1]
      delete logout_path #log out user

      expect { delete cheatsheet_path(@cheatsheet) }.not_to change(Cheatsheet, :count)
      expect(response).to redirect_to(login_url)
    end

    it 'should redirect destroy when logged in user is not the author of cheatsheet' do
      @cheatsheet = @user.cheatsheets[1]
      delete logout_path #log out user
      follow_redirect!
      log_in_as(@other_user, password: 'password123', remember_me: '1')

      expect { delete cheatsheet_path(@cheatsheet) }.not_to change(Cheatsheet, :count)
      expect(response).to redirect_to(login_url)
    end

    it 'should display edit and delete only if logged in user is author of cheatsheet' do
      get my_cheatsheets_user_path(@user)

      expect(response).to render_template('users/my_cheatsheets')
      first_page_of_cheatsheets = @user.cheatsheets.where(visibility: true).paginate(page: 1)
      first_page_of_cheatsheets.each do |cheatsheet|
        assert_select 'a[href=?]', cheatsheet_path(cheatsheet), text: cheatsheet.title
        if @user == cheatsheet.user_id
          assert_select 'a[href=?]', edit_cheatsheet_path(cheatsheet), text: 'edit'
          assert_select 'a[href=?]', cheatsheet_path(cheatsheet), text: 'delete'
        end
      end
    end

    it "should delete the cheatsheet if the logged in user and the author of the cheatsheet" do
      @cheatsheet = @user.cheatsheets[1]

      expect { delete cheatsheet_path(@cheatsheet) }.to change(Cheatsheet, :count)
      expect(flash[:success]).to eq("Cheatsheet deleted")
      expect(response).to redirect_to(my_cheatsheets_user_path)    
    end

  end

  describe 'edit' do
    it 'should not update if the title, content, or tags fields are blank' do
      @cheatsheet = @user.cheatsheets[1]
      get edit_cheatsheet_path(@cheatsheet)
      
      expect(response).to render_template('cheatsheets/edit')
      patch cheatsheet_path(@cheatsheet), params: { cheatsheet: { title: '', content: '', tag_list: '', user_id: @user.id } }

      expect(response).to render_template('cheatsheets/edit')
    end

    it 'should redirect edit when user is not author of cheatsheet' do
      @cheatsheet = @user.cheatsheets[1]
      delete logout_path #log out user
      follow_redirect!
      log_in_as(@other_user, password: 'password123', remember_me: '1')
      get edit_cheatsheet_path(@cheatsheet)

      expect(response).to redirect_to(login_url)
    end

    it 'should reload the form with new information when successful' do
      @cheatsheet = @user.cheatsheets[1]
      get edit_cheatsheet_path(@cheatsheet)
      
      expect(response).to render_template('cheatsheets/edit')
      patch cheatsheet_path(@cheatsheet), params: { cheatsheet: { title: 'New title', 
                                                                  content: 'New content', 
                                                                  tag_list: 'new', 
                                                                  user_id: @user.id } }

      expect(response).to redirect_to(cheatsheet_url)
      expect(flash[:success]).to eq("Cheatsheet updated")
      @cheatsheet.reload
      expect(@cheatsheet.title).to eq('New title')
      expect(@cheatsheet.content).to eq('New content')
      expect(@cheatsheet.tag_list).to eq(['new'])
    end
  end
end
