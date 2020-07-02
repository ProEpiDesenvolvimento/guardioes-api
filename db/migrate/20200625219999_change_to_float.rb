class ChangeToFloat < ActiveRecord::Migration[5.2]
  remove_column :syndrome_symptom_percentages, :syndrome_symptom_percentage
  add_column :syndrome_symptom_percentages, :percentage, :float
end
  