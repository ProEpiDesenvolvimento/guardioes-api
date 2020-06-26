class Syndrome < ApplicationRecord
    has_one :message
    accepts_nested_attributes_for :message

    has_many :syndrome_symptom_percentages, :through => :symptoms
    has_many :symptoms
    accepts_nested_attributes_for :symptoms
end