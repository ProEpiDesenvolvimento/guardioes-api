class AddWentToHospitalToSurveys < ActiveRecord::Migration[5.2]
  def self.up
    add_column :surveys, :went_to_hospital, :string
  end

  def self.down
    remove_column :surveys, :went_to_hospital
  end
end
