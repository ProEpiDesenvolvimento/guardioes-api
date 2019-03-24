class AddDeletedAtToSurveys < ActiveRecord::Migration[5.2]
  def up
    add_column :surveys, :deleted_at, :datetime
    add_index :surveys, :deleted_at
  end

  def down
    remove_index :suveys, :deleted_at
    remove_column :surveys, :deleted_at
  end
end
