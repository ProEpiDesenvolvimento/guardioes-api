class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :warning_message, :go_to_hospital_message, :feedback_message, :day
  belongs_to :syndrome
end
