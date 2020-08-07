class AddIconToContents < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :icon, :string
  end
end
