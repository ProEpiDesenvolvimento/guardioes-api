class AddSchoolUnitIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :school_unit, foreign_key: true
  end
end
