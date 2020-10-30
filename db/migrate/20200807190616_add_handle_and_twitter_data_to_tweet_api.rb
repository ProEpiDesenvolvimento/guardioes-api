class AddHandleAndTwitterDataToTweetApi < ActiveRecord::Migration[5.2]
  def change
    add_column :twitter_apis, :twitterdata, :string
    add_column :twitter_apis, :handle, :string
  end
end
