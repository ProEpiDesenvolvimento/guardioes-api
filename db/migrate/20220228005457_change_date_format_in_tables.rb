class ChangeDateFormatInTables < ActiveRecord::Migration[5.2]
  def up
    change_column :households, :birthdate, :datetime
    change_column :surveys, :bad_since, :datetime
  end

  def down
    change_column :households, :birthdate, :date
    change_column :surveys, :bad_since, :date
  end
end
