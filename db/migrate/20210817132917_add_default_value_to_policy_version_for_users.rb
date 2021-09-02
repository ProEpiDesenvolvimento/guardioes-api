class AddDefaultValueToPolicyVersionForUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :policy_version, from: 1, to: 2
  end
end
