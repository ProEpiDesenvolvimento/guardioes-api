class AddStreakToHousehold < ActiveRecord::Migration[5.2]
  def change
    add_column :households, :streak, :integer, :default => 0
  end
end
