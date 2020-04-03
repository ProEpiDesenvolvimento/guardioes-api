class ChangeTypeOfContactWithSymptoms < ActiveRecord::Migration[5.2]
  def change
    change_column :surveys, :contact_with_symptom, :string
  end
end
