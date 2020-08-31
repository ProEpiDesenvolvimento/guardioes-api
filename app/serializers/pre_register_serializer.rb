class PreRegisterSerializer < ActiveModel::Serializer
  attributes :id, :cnpj, :phone, :organization_kind, :state, :company_name
  has_one :app
end
