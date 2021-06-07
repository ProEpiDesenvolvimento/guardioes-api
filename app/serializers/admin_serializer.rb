class AdminSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :password_changed, :is_god, :created_by, :updated_by, :app_id
end
