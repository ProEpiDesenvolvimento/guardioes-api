class Group < ApplicationRecord
  acts_as_paranoid
  belongs_to :manager
  has_many :users
end
