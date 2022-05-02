class AddLatitudeAndLongitudeToRumor < ActiveRecord::Migration[5.2]
  def change
    add_column :rumors, :latitude, :float
    add_column :rumors, :longitude, :float
  end
end
