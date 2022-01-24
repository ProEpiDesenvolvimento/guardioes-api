class Dose < ApplicationRecord
  belongs_to :vaccine
  belongs_to :user

    validates :date,
      presence: true
    
    validates :dose,
      presence: true,
      numericality: true
      
		
end
