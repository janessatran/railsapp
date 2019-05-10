class AddVisbilityToCheatsheets < ActiveRecord::Migration[5.2]
  def change
    add_column :cheatsheets, :visibility, :boolean, :default => true
    change_column :cheatsheets, :title, :string, :limit => 1000
  end
end
