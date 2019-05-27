class StaticPagesController < ApplicationController
  def home; end

  def search
    if params[:search].blank?
      redirect_to(root_path, alert: 'Empty field!') && return
    else
      @parameter = params[:search].downcase
      @results = Cheatsheet.tagged_with("#{@parameter}")
    end
  end
end
