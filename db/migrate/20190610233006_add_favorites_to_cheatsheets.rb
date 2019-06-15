class AddFavoritesToCheatsheets < ActiveRecord::Migration[5.2]
  def change
    add_column :cheatsheets, :favorites, :number
  end
end
