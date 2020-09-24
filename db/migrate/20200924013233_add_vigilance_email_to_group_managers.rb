class AddVigilanceEmailToGroupManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :vigilance_email, :string
  end
end
