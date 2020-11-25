class AppSerializer < ActiveModel::Serializer
  attributes :id, :app_name, :owner_country, :twitter

  has_many :contents
  has_many :symptoms
end
