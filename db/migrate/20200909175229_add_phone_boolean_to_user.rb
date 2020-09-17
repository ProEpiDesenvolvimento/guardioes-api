class AddPhoneBooleanToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone, :string
    add_column :users, :is_vigilance, :boolean, default: false
  end
end
