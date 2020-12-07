# frozen_string_literal: true

class PublicHospital < ApplicationRecord
  belongs_to :app

  scope :filter_hospitals_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
