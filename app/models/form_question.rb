class FormQuestion < ApplicationRecord
  belongs_to :form

  has_many :form_options, -> { order(order: :asc) }, :dependent => :destroy
end
