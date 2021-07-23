class CreateVaccine < ActiveRecord::Migration[5.2]
  def change
    create_table :vaccines do |t|
      t.string :name
      t.string :laboratory
      t.string :country_origin
      t.integer :doses
      t.integer :max_dose_interval
      t.integer :max_dose_interval
    end
  end
end
