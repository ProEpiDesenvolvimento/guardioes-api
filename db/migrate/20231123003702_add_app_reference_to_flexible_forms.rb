class AddAppReferenceToFlexibleForms < ActiveRecord::Migration[5.2]
  def change
    add_reference :flexible_forms, :app, foreign_key: true
  end
end
