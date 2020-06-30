class AddFiltersToSchoolUnits < ActiveRecord::Migration[5.2]
  def change
    add_column :school_units, :category, :string
    add_column :school_units, :zone, :string
    add_column :school_units, :level, :string
    add_column :school_units, :city, :string
    add_column :school_units, :state, :string
  end
end
