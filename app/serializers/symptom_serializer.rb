class SymptomSerializer < ActiveModel::Serializer
  attributes :id, :description, :code, :priority, :details
  has_one :app
end
