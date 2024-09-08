class CommunityGroup < ApplicationRecord
  validates :name,
  presence: true,
    length: {
      minimum: 1,
      maximum: 255
  }
end
