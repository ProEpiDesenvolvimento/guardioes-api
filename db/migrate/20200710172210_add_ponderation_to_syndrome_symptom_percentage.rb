class AddPonderationToSyndromeSymptomPercentage < ActiveRecord::Migration[5.2]
  def change
    add_column :syndrome_symptom_percentages, :ponderation, :float
  end
end
