class CityManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :city, :created_by, :updated_by, :deleted_by, :first_access, :app_id
end
