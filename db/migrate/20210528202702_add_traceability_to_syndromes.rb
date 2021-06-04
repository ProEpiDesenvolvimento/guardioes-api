class AddTraceabilityToSyndromes < ActiveRecord::Migration[5.2]
  def change
    add_column :syndromes, :created_by, :string
    add_column :syndromes, :updated_by, :string
    add_column :syndromes, :deleted_by, :string
  end
end
