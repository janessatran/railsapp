class CheatsheetsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
  before_action :require_public, only: [:show]
  before_action :correct_user, only: [:destroy, :edit, :update]

  def new
    if logged_in?
      @cheatsheet = Cheatsheet.new 
    else
      redirect_to login_url
    end
  end

  def index
    @cheatsheets = Cheatsheet.all.where(visibility: true).paginate(page: params[:page], :per_page => 7)
  end

  def show
    @cheatsheet = Cheatsheet.find(params[:id])
    @user = current_user
  end

  def create
    @cheatsheet = current_user.cheatsheets.build(cheatsheet_params)
    if @cheatsheet.save
      flash[:success] = "Your cheatsheet has been created!"
      redirect_to @cheatsheet
    else
      render 'new'
      @feed_items = []
      flash[:danger] = "Your cheatsheet is missing required values!"
    end
  end

  def edit
    @cheatsheet = Cheatsheet.find(params[:id])
  end

  def update
    @cheatsheet = Cheatsheet.find(params[:id])
    if @cheatsheet.update_attributes(cheatsheet_params)
      # Handle a successful update.
      flash[:success] = "Cheatsheet updated"
      redirect_to @cheatsheet
    else
      render 'edit'
    end
  end

  def destroy
    Cheatsheet.find(params[:id]).destroy
    flash[:success] = "Cheatsheet deleted"
    redirect_to my_cheatsheets_user_path
  end
  
  private

    def cheatsheet_params
      params.require(:cheatsheet).permit(:title, :content,
                                   :user_id, :tag_list, :visibility)
    end

    def require_public
      @cheatsheet = Cheatsheet.find(params[:id])
      if @cheatsheet[:visibility] == false
        redirect_to(root_url)  unless (logged_in? && (current_user.id == @cheatsheet.user_id))
      end
    end

    # Confirms the correct user.
    def correct_user
      @cheatsheet = Cheatsheet.find(params[:id])
      redirect_to(login_url) unless current_user?(current_user) && @cheatsheet.user_id == current_user.id
    end
end
