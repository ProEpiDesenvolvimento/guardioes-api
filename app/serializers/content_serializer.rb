class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :icon, :content_type, :source_link, :created_at, :updated_at, :created_by, :updated_by
  has_one :app
end
