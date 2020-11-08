class AddManagerToApp < ActiveRecord::Migration[5.2]
  def change
    add_reference :apps, :manager, foreign_key: true
  end
end
