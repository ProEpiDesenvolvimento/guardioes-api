# frozen_string_literal: true

class App < ApplicationRecord
  has_many :admins
  has_many :users
  has_many :symptoms
  has_many :public_hospitals
  has_many :contents
  has_many :group_managers
  has_many :managers

  searchkick unless Rails.env.test?

  validates :app_name,
            presence: true,
            length: {
              minimum: 1,
              maximum: 255
            }

  validates :owner_country,
            presence: true,
            length: {
              minimum: 1,
              maximum: 255
            }
end
