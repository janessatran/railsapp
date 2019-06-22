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
    # def favorite_params
    #   params.require(:favorite).permit(:cheatsheet_id, :user_id)
    # end

    def find_favorite
      @favorite = @cheatsheet.favorites.find(params[:id])
    end

    def find_cheatsheet
      @cheatsheet = Cheatsheet.find(params[:cheatsheet_id])
    end

    def already_liked?
      if params[:id].nil? == false
        Favorite.find(params[:id])
      else
        Favorite.where(user_id: current_user.id, cheatsheet_id: params[:cheatsheet_id]).exists?
      end
    end
end
