class Vaccine < ApplicationRecord
  belongs_to :app

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

	validates :max_dose_interval,
		presence: true,
		numericality: {
			greater_than_or_equal_to: :min_dose_interval,
			allow_nil: true
		}
	
	validates :min_dose_interval,
		presence: true,
		numericality: {
			less_than_or_equal_to: :max_dose_interval,
			allow_nil: true
		}
end
