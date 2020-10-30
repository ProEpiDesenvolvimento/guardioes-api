class SymptomSerializer < ActiveModel::Serializer
  attributes :id, :description, :code, :priority, :details, :message
  has_one :app
end
