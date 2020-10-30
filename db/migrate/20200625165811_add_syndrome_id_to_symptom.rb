class AddSyndromeIdToSymptom < ActiveRecord::Migration[5.2]
  def change
    add_reference :symptoms, :syndrome, foreign_key: true
  end
end
