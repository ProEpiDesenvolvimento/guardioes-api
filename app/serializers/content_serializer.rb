class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :icon, :content_type, :source_link
  has_one :app
end
