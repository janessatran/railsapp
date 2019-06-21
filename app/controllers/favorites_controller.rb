class FavoritesController < ApplicationController
  before_action :logged_in_user
  before_action :find_cheatsheet
  before_action :find_favorite, only: [:destroy]

  # Add a favorite
  def create
    @cheatsheet.favorites.create(user_id: current_user.id) unless already_liked?
    respond_to do |format|
      format.html { redirect_to @cheatsheet }
      format.js
    end
  end

  # Remove a favorite
  def destroy
    @favorite.destroy if already_liked?
    respond_to do |format|
      format.html { redirect_to @cheatsheet }
      format.js
    end
  end


  private

    def find_favorite
      puts "I'm in here!"
      @favorite = @cheatsheet.favorites.find(params[:id])
    end

    def find_cheatsheet
      puts "I'm in this one!"
      @cheatsheet = Cheatsheet.find(params[:cheatsheet_id])
    end

    def already_liked?
      puts "I'm in already_liked?"
      Favorite.where(user_id: current_user.id, cheatsheet_id: params[:cheatsheet_id]).exists?
    end

    def favorites_params
      params.require(:favorite).permit(:cheatsheet_id, :user_id)
    end
end
