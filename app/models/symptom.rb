class Symptom < ApplicationRecord
  belongs_to :app
  if !Rails.env.test?
    searchkick
  end

  has_one :message, dependent: :destroy
  accepts_nested_attributes_for :message
 
  scope :filter_symptom_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
 