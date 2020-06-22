class AddSourceLinkToContent < ActiveRecord::Migration[5.2]
  def change
    add_column :contents, :source_link, :string
  end
end
