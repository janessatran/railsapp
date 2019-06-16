class AddVisbilityToCheatsheets < ActiveRecord::Migration[5.2]
  def up
    add_column :cheatsheets, :visibility, :boolean, :default => 0
    change_column :cheatsheets, :title, :string, :limit => 1000
  end

  def down
    remove_column :cheatsheets, :visibility, :boolean, :default => 0
    change_column :cheatsheets, :title, :string
  end

end
