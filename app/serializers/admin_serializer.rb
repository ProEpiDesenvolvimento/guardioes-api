class AdminSerializer < ActiveModel::Serializer
  attributes :id, :email, :app_id, :first_name, :last_name
end
