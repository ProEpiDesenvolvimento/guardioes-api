class Household < ApplicationRecord
  belongs_to :user, optional: true
end
