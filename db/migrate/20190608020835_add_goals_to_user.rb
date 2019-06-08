class AddGoalsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :learning_goals, :text
  end
end
