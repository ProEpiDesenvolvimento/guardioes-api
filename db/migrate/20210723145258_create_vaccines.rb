class CreateVaccines < ActiveRecord::Migration[5.2]
  def change
    create_table :vaccines do |t|
      t.string :name
      t.string :laboratory
      t.integer :doses
      t.integer :max_dose_interval
      t.integer :min_dose_interval
      t.string :country_origin

      t.timestamps
    end
  end
end
