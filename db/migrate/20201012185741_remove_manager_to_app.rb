class RemoveManagerToApp < ActiveRecord::Migration[5.2]
  def change
    remove_reference :apps, :manager, foreign_key: true
  end
end
