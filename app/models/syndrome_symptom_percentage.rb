class Syndrome::SyndromeSymptomPercentage < ApplicationRecord
  belongs_to :syndrome
  belongs_to :symptom
end
