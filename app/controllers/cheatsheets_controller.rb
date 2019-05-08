class CheatsheetsController < ApplicationController
  # def new
  #   @cheatsheet = Cheatsheet.new
  # end

  private

    def cheatsheet_params
      params.require(:cheathseet).permit(:title, :topic, :body,
                                   :author)
    end
end
