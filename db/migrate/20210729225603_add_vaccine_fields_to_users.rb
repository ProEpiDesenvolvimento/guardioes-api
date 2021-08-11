class AddVaccineFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_dose_date, :datetime
    add_column :users, :second_dose_date, :datetime
    add_reference :users, :vaccine, foreign_key: true
  end
end
