class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @cheatsheets  = current_user.cheatsheets.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def search
    if params[:search].blank?
      redirect_to(root_path, alert: 'Empty field!') && return
    else
      @parameter = params[:search].downcase
      @results = Cheatsheet.tagged_with("#{@parameter}")
    end
  end
end
