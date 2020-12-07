# frozen_string_literal: true

class SyndromeSymptomPercentage < ApplicationRecord
  belongs_to :symptom
  belongs_to :syndrome
end
