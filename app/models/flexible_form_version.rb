class FlexibleFormVersion < ApplicationRecord
  belongs_to :flexible_form
  has_one :group_manager, through: :flexible_form
  has_many :flexible_answers, dependent: :destroy

  def group_manager_id
    flexible_form.group_manager_id
  end
end
