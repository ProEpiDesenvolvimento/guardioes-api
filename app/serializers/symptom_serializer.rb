class SymptomSerializer < ActiveModel::Serializer
  attributes :id, :description, :code, :priority, :details
  has_one :app
  has_one :syndrome_symptom_percentage, :serializer => SyndromeSymptomPercentageSerializer
end
