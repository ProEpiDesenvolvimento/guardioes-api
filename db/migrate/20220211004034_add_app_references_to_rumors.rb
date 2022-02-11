class AddAppReferencesToRumors < ActiveRecord::Migration[5.2]
  def change
    add_reference :rumors, :app, foreign_key: true
  end
end
