class Survey < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :household, optional:true
  before_validation :reverse_geocode
  
  serialize :symptom, Array
   
  def address
    [street, city, state, country].compact.join(', ')
  end
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.country = geo.country
      obj.street  = geo.street
      obj.state   = geo.state
    end
  end
 
  def self.to_csv
    attributes = %w{id latitude longitude bad_since traveled_to symptom created_at street city state country went_to_hospital contact_with_symptom}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  scope :filter_by_user, ->(user) { where(user_id: user) }
end
