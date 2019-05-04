class StaticPagesController < ApplicationController
  def home
    render html: 'homepage placeholder :)'
  end
end
