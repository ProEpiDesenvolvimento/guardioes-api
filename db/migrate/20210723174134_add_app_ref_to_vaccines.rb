class AddAppRefToVaccines < ActiveRecord::Migration[5.2]
  def change
    add_reference :vaccines, :app, foreign_key: true
  end
end
