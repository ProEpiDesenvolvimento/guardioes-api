class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :icon, :content_type, :source_link, :created_at, :updated_at
  has_one :app
end
