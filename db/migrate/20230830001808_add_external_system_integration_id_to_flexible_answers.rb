class AddExternalSystemIntegrationIdToFlexibleAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :flexible_answers, :external_system_integration_id, :string
  end
end
