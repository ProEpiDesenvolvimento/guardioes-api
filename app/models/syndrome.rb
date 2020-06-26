class Syndrome < ApplicationRecord
    has_one :message
    accepts_nested_attributes_for :message

    has_many :symdrome_symptom_percentages, :class_name => 'SyndromeSymptomPercentage'
    has_many :symptoms, through: :symdrome_symptom_percentages
    accepts_nested_attributes_for :symptoms
end
