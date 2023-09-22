class FlexibleForm < ApplicationRecord
  belongs_to :group_manager
  has_many :flexible_form_versions, -> { order(created_at: :desc) }, dependent: :destroy

  def flexible_form_version
    flexible_form_versions.first
  end
end
