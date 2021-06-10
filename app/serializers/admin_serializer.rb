class AdminSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :is_god, :created_by, :updated_by, :first_access, :app_id
end
