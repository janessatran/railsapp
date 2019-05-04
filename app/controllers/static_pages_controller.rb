class StaticPagesController < ApplicationController
  def home; end

  def search
    if params[:search].blank?  
      redirect_to(root_path, alert: "Empty field!") and return  
    else  
    end
  end
end
