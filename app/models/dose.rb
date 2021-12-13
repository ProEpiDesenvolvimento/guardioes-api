class Dose < ApplicationRecord
  belongs_to :vaccine
  belongs_to :user
end
