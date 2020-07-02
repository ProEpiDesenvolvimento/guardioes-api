class AddSyndromeToSyndromeSymptomPercentage < ActiveRecord::Migration[5.2]
  def change
    add_reference :syndrome_symptom_percentages, :syndrome, foreign_key: true
  end
end
