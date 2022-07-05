class AddUserToRumors < ActiveRecord::Migration[5.2]
  def change
    add_reference :rumors, :user, foreign_key: true
  end
end
