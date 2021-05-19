class AddDaysPeriodToSyndromes < ActiveRecord::Migration[5.2]
  def change
    add_column :syndromes, :days_period, :integer
  end
end
