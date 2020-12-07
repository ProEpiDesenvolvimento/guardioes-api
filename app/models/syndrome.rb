# frozen_string_literal: true

class Syndrome < ApplicationRecord
  belongs_to :app
  searchkick unless Rails.env.test?

  has_one :message, dependent: :destroy
  accepts_nested_attributes_for :message

  has_many :syndrome_symptom_percentage, class_name: 'SyndromeSymptomPercentage', dependent: :destroy
  has_many :symptoms, through: :syndrome_symptom_percentage

  scope :filter_syndrome_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
