class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :content_type, :source_link
  has_one :app
end
