class AddInTrainingAndIsVbeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_vbe, :boolean, default: false, null: false
    add_column :users, :in_training, :boolean, default: false, null: false
  end
end
