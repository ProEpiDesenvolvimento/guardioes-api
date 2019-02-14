class AppSerializer < ActiveModel::Serializer
  attributes :id, :app_name, :owner_country
end
