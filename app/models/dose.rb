class Dose < ApplicationRecord
  belongs_to :vaccine
  belongs_to :user

  validates :date,
    presence: true
  
  validates :dose,
    presence: true,
    numericality: true
  
  # Migrates doses from user attributes to doses table
  def self.migrate_doses
    User.where.not(vaccine_id: nil).each do |u|
      vaccine_id = u.vaccine_id
  
      if u.first_dose_date.present?
        @dose_1 = Dose.new(date: u.first_dose_date, dose: 1, vaccine_id: vaccine_id, user_id: u.id)
      end

      if u.second_dose_date.present?
        @dose_2 = Dose.new(date: u.second_dose_date, dose: 2, vaccine_id: vaccine_id, user_id: u.id)
      end
      # need set first_dose_date and second_dose_date to nil on next release
    end
  end
		
end
