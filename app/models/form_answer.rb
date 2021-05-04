class FormAnswer < ApplicationRecord
  belongs_to :form
  belongs_to :form_question
  belongs_to :form_option
  belongs_to :user
end
