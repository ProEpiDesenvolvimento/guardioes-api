class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :warning_message, :go_to_hospital_message, :day
  belongs_to :syndrome
end
