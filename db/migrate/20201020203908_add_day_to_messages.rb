class AddDayToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :day, :integer, :default => -1
  end
end
