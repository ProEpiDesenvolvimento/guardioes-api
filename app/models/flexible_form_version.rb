class FlexibleFormVersion < ApplicationRecord
  belongs_to :flexible_form
  has_many :flexible_answers, dependent: :destroy
end
