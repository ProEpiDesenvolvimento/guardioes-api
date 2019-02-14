class Survey < ApplicationRecord
  belongs_to :user
  belongs_to :household, optional:true
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
  after_validation :reverse_geocode
 
end
