class Category < ApplicationRecord
  has_many :users
  
  validates :name,
  presence: true,
    length: {
      minimum: 1,
      maximum: 255
  }
end
