class Household < ApplicationRecord
  acts_as_paranoid
  
  validates_presence_of :description, 
                        :birthdate, 
                        :country,
                        :user_id,
                        :kinship

  validates :description,
    length: {
      minimum: 1,
      maximum: 255,
      too_short: I18n.translate("household.validations.description.too_short"),
      too_long: I18n.translate("household.validations.description.too_long")
    }
  
  belongs_to :user
  belongs_to :category, optional: true
  has_many :surveys, dependent: :destroy

  belongs_to :group, optional: true

  scope :filter_by_user, ->(user) { where(user_id: user) }
end
