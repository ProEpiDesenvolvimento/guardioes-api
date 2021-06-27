class SymptomSerializer < ActiveModel::Serializer
  attributes :id, :description, :code, :priority, :details, :message, :created_by, :updated_by
  has_one :app
end
