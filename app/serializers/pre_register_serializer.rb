class PreRegisterSerializer < ActiveModel::Serializer
  attributes :id, :cnpj, :phone, :organization_kind, :state, :company_name, :email
  has_one :app
end
