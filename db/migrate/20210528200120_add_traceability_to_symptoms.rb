class AddTraceabilityToSymptoms < ActiveRecord::Migration[5.2]
  def change
    add_column :symptoms, :created_by, :string
    add_column :symptoms, :updated_by, :string
    add_column :symptoms, :deleted_by, :string
  end
end
