class FlexibleForm < ApplicationRecord
  belongs_to :app
  belongs_to :group_manager, optional: true
  has_many :flexible_form_versions, -> { order(created_at: :desc) }, dependent: :destroy

  def flexible_form_version
    flexible_form_versions.first
  end
end
