class ManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :password_changed, :created_by, :updated_by, :app_id
end
