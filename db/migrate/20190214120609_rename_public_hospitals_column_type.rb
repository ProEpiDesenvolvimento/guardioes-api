class RenamePublicHospitalsColumnType < ActiveRecord::Migration[5.2]
  def change
    rename_column :public_hospitals, :type, :public_hospital_type
  end
end
