class CityManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :city, :app_id
end
