class Content < ApplicationRecord
  belongs_to :app
  belongs_to :group_manager, optional: true

  scope :admin_country, ->(current_admin_app) { where(app_id: current_admin_app) }
  scope :user_country, ->(current_user_app) { where(app_id: current_user_app) }
end
