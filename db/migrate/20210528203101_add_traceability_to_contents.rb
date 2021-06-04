class AddTraceabilityToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :created_by, :string
    add_column :contents, :updated_by, :string
    add_column :contents, :deleted_by, :string
  end
end
