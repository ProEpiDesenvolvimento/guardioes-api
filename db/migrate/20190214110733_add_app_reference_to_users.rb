class AddAppReferenceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :app, foreign_key: true
  end
end
