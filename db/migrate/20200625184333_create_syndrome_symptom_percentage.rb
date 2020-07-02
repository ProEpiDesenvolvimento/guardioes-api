class CreateSyndromeSymptomPercentage < ActiveRecord::Migration[5.2]
  def change
    create_table :syndrome_symptom_percentages do |t|
      t.string :syndrome_symptom_percentage
    end
  end
end
