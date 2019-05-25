class CheatsheetsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def new
    if logged_in?
      @cheatsheet = Cheatsheet.new 
    else
      redirect_to login_url
    end
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
    end
  end

  private

    def cheatsheet_params
      params.require(:cheatsheet).permit(:title, :topic, :content,
                                   :user_id)
    end
end
