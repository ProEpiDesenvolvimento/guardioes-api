class Syndrome < ApplicationRecord
    has_one :message
    accepts_nested_attributes_for :message

    has_many :syndrome_symptom_percentage, :class_name => 'SyndromeSymptomPercentage'
    has_many :symptoms, :through => :syndrome_symptom_percentage 
end