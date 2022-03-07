class ChangeDateFormatInDose < ActiveRecord::Migration[5.2]
  def up
    change_column :doses, :date, :datetime
  end

  def down
    change_column :doses, :date, :date
  end
end
