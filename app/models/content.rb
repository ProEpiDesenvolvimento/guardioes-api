class Content < ApplicationRecord
  belongs_to :app

  scope :admin_country, ->(current_admin_app) { where(app_id: current_admin_app) }
end
