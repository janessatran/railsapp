class DropTopics < ActiveRecord::Migration[5.2]
  def change
    drop_table :topics
  end
end
