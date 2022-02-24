class AddDiseaseToVaccine < ActiveRecord::Migration[5.2]
  def change
    add_column :vaccines, :disease, :string
  end
end
