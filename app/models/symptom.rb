class Symptom < ApplicationRecord
  belongs_to :app


  has_one :message
  accepts_nested_attributes_for :message
 
  has_one :syndrome_symptom_percentage 
  scope :filter_symptom_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
 