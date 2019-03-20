class AddDeletedAtToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :deleted_at, :datetime
    add_index :surveys, :deleted_at
  end
end
