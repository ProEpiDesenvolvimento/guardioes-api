class AddIdentificationCodeToHouseholds < ActiveRecord::Migration[5.2]
  def change
    add_column :households, :identification_code, :string
  end
end
