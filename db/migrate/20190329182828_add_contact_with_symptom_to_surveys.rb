class AddContactWithSymptomToSurveys < ActiveRecord::Migration[5.2]
  def self.up
    add_column :surveys, :contact_with_symptom, :boolean
  end

  def self.down
    remove_column :surveys, :contact_with_symptom
  end
end
