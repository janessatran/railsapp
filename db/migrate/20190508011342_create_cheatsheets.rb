class CreateCheatsheets < ActiveRecord::Migration[5.2]
  def change
    create_table :cheatsheets do |t|
      t.string :title
      t.string :topic
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
