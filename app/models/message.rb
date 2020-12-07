# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :syndrome, optional: true
  belongs_to :symptom, optional: true
end
