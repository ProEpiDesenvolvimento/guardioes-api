class SchoolUnitSerializer < ActiveModel::Serializer
  attributes :id, :code, :description, :address, :cep, :phone, :fax, :email
end
