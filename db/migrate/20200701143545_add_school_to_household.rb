class AddSchoolToHousehold < ActiveRecord::Migration[5.2]
  def change
    add_reference :households, :school_unit, foreign_key: true
  end
end
