class AdminSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :is_god, :created_by, :updated_by, :deleted_by, :app_id
end
