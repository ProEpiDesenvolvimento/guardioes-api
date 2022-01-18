class AddFieldsToHouseholds < ActiveRecord::Migration[5.2]
  def change
    add_reference :households, :category, foreign_key: true
  end
end
