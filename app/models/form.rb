class Form < ApplicationRecord
  belongs_to :group_manager
  has_many :form_questions, :dependent => :destroy
  has_many :form_answers, :dependent => :destroy
end
