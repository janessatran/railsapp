class CheatsheetsController < ApplicationController
  def new
    @cheatsheet = Cheatsheet.new
  end

  def show
    @cheatsheet = Cheatsheet.find(params[:id])
  end

  def create
    @cheatsheet = Cheatsheet.new(cheatsheet_params)
    if @cheatsheet.save
      flash[:success] = "Welcome to the Learning Together community!"
      redirect_to @cheatsheet
    else
      render 'new'
    end
  end

  private

    def cheatsheet_params
      params.require(:cheathseet).permit(:title, :topic, :content,
                                   :author)
    end
end
