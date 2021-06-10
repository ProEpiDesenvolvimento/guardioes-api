class ManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_by, :updated_by, :first_access, :app_id
end
