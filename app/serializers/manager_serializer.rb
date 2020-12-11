class ManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :app_id
end
