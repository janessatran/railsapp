class DropTopics < ActiveRecord::Migration[5.2]
  def up
    drop_table :topics
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
