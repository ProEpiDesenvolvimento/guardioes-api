class AddFeedbackMessageToMessages < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :messages, :feedback_message
      add_column :messages, :feedback_message, :string
    end
  end
end
