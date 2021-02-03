class AddPolicyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :policy_version, :integer, default: 1, null: false
  end
end
