class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :type
  has_one :app
end
