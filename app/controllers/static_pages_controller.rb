class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = current_user.feed.where(visibility: true).paginate(page: params[:page])
    end
  end

  def search
    if params[:search].blank?
      redirect_to(root_path, alert: 'Empty field!') && return
    else
      @tag = params[:search].downcase
      @cheatsheets = Cheatsheet.tagged_with("#{@tag}").where(visibility: true).paginate(page: params[:page])
    end
  end
end
