class AddUrlGoDataToGroupManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :url_godata, :text, default: ""
  end
end
