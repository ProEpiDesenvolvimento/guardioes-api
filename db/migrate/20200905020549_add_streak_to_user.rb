class AddStreakToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :streak, :integer, :default => 0
  end
end
