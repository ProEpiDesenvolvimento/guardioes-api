class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :icon, :content_type, :source_link,
             :created_at, :updated_at, :group_manager_id, :app_id
end
