class AddTwitterToApp < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :twitter, :string
  end
end
