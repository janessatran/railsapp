class CheatsheetsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :require_public, only: [:show]

  def new
    if logged_in?
      @cheatsheet = Cheatsheet.new 
    else
      redirect_to login_url
    end
  end

  def index
    @cheatsheet = Cheatsheet.all.where(visibility: true)
  end

  def show
    @cheatsheet = Cheatsheet.find(params[:id])
  end

  def create
    @cheatsheet = current_user.cheatsheets.build(cheatsheet_params)
    if @cheatsheet.save
      flash[:success] = "Your cheatsheet has been created!"
      redirect_to @cheatsheet
    else
      render 'new'
      @feed_items = []
      flash[:danger] = "Your cheatsheet is missing required!"
    end
  end

  def favorites
    @title = "Favorites"
    @cheatsheet  = Cheatsheet.find(params[:id])
    @favorites = @cheatsheets.favorites.paginate(page: params[:page])
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
end
