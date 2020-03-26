class ChangeTheColumnType < ActiveRecord::Migration[5.2]
  def change
    rename_column :public_hospitals, :type, :kind
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
