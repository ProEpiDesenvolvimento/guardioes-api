class CreateSchoolUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :school_units do |t|
      t.string :code
      t.string :description
      t.string :address
      t.string :cep
      t.string :phone
      t.string :fax
      t.string :email

      t.timestamps
    end
  end
end
