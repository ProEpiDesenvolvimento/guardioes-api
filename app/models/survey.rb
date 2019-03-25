class Survey < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :household, optional:true
  before_validation :reverse_geocode
  
  serialize :symptom, Array
 
  validates_presence_of :user_id,
    :household_id,
    :latitude,
    :longitude,
    :symptom,
    :street,
    :city,
    :state,
    :country
  
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
 
end
