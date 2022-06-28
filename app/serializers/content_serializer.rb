class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :icon, :content_type, :source_link, :group_manager_id, :app_id,
             :created_at, :updated_at, :updated_by
end
