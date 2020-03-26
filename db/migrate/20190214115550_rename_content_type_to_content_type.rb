class RenameContentTypeToContentType < ActiveRecord::Migration[5.2]
  def up
    rename_column :contents, :type, :content_type
  end
end
