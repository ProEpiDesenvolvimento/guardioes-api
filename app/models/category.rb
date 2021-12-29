class Category < ApplicationRecord
  has_many :users
  has_many :households
  
  validates :name,
  presence: true,
    length: {
      minimum: 1,
      maximum: 255
  }
end
