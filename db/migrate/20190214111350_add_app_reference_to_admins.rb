class AddAppReferenceToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_reference :admins, :app, foreign_key: true
  end
end
