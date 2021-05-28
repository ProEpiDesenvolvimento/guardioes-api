class ManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_by, :updated_by, :deleted_by, :app_id
end
