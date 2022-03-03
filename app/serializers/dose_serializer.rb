class DoseSerializer < ActiveModel::Serializer
  attributes :id, :date, :dose, :user_id, :vaccine
end