class AddAppReferenceToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_reference :city_managers, :app, foreign_key: true
  end
end
