class FormOption < ApplicationRecord
  belongs_to :form_question
  has_many :form_answers, :dependent => :destroy
end
