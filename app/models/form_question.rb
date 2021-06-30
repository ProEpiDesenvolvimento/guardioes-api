class FormQuestion < ApplicationRecord
  belongs_to :form
  has_many :form_options, :dependent => :destroy
end
