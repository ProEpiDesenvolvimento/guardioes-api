class AddRiskGroupToHouseholds < ActiveRecord::Migration[5.2]
  def change
    add_column :households, :risk_group, :boolean
  end
end
