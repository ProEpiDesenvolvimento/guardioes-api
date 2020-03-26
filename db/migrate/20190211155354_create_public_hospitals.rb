class CreatePublicHospitals < ActiveRecord::Migration[5.2]
  def change
    create_table :public_hospitals do |t|
      t.string :description
      t.float :latitude
      t.float :longitude
      t.string :type
      t.string :phone
      t.text :details
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
