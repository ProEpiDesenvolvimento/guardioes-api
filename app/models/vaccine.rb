class Vaccine < ApplicationRecord
  belongs_to :app
  has_many :users
  has_many :dose,
  	dependent: :destroy

	validates :name,
		presence: true,
			length: {
				minimum: 1,
				maximum: 255
		}

	validates :country_origin,
		presence: true,
		length: {
			minimum: 1,
			maximum: 255
		}
	
	validates :doses,
		presence: true,
		numericality: {
			greater_than: 0,
			less_than: 10,
		}
	
	validates :laboratory,
		presence: true,
		length: {
			minimum: 1,
			maximum: 255
		}
		scope :filter_vaccine_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
