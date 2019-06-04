class AddPicToHousehold < ActiveRecord::Migration[5.2]
  def change
    add_column :households, :picture, :string
  end
end
