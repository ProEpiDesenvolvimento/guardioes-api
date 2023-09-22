class FlexibleAnswer < ApplicationRecord
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user
end
