# frozen_string_literal: true

class Household < ApplicationRecord
  acts_as_paranoid
  searchkick unless Rails.env.test?

  validates_presence_of :description,
                        :birthdate,
                        :country,
                        :gender,
                        :race,
                        :user_id,
                        :kinship

  validates :description,
            length: {
              minimum: 1,
              maximum: 255,
              too_short: I18n.translate('household.validations.description.too_short'),
              too_long: I18n.translate('household.validations.description.too_long')
            }

  belongs_to :user
  has_many :surveys, dependent: :destroy

  has_one :school_unit
  belongs_to :group, optional: true

  scope :filter_by_user, ->(user) { where(user_id: user) }
end
