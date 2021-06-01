class CityManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :city, :created_by, :updated_by, :deleted_by, :app_id
end
