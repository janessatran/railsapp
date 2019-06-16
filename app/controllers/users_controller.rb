class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
    :following, :followers, :favorites, :favorited]
  before_action :correct_user,   only: [:edit, :update, :private_cheatsheets]
  before_action :admin_user,     only: :destroy
  protect_from_forgery

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @cheatsheets = @user.cheatsheets
    redirect_to root_url and return unless (@user.activated)
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the App!"
      # redirect_to @user
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def favorites
    @title = "Favorite Cheatshets"
    @user = User.find(params[:id])
    @favorites = @user.favorites.paginate(page: params[:page])
    render 'show_favorites'
  end

  def public_cheatsheets
    @user = User.find(params[:id])
    @public_cheatsheets = @user.cheatsheets.where(visibility: true)
  end

  def private_cheatsheets
    @user = User.find(params[:id])
    @private_cheatsheets = @user.cheatsheets.where(visibility: false)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :bio, :title, :github, :twitter,
                                   :learning_goals)
    end

     # Confirms the correct user.
     def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
