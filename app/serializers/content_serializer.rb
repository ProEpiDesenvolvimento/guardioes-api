class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :content_type
  has_one :app
end
