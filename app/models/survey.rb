class Survey < ApplicationRecord
  acts_as_paranoid
  searchkick
    
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
  
  def get_message
    @user_symptoms = []
    symptom.map { |symptom|
      if Symptom.where(:description=>symptom).any?
        @user_symptoms.append(Symptom.where(:description=>symptom)[0])
      end
    }
    symptoms_and_syndromes_data = {}
    symptom_messages = get_symptoms_messages
    if symptom_messages.any?
      symptoms_and_syndromes_data[:symptom_messages] = symptom_messages
    end
    top_3 = get_top_3_syndromes
    if top_3.any?
      symptoms_and_syndromes_data[:top_3] = top_3.map { |obj| { name: obj[:syndrome].description, percentage: obj[:likelyhood] }}
      syndrome_message = top_3[0][:syndrome].message
      if !syndrome_message.nil?
        symptoms_and_syndromes_data[:top_syndrome_message] = syndrome_message || ''
      end
    end
    return symptoms_and_syndromes_data
  end
 
  scope :filter_by_user, ->(user) { where(user_id: user) }
 
  # Data that gets sent as fields for elastic indexes
  def search_data
    user = nil
    elastic_data = self.as_json() 
    if !self.household_id.nil?
      user = Household.find(self.household_id)
    else
      user = self.user
    end
    elastic_data[:identification_code] = user.identification_code
    elastic_data[:gender] = user.gender 
    elastic_data[:race] = user.race 
    if !user.school_unit_id.nil? 
      elastic_data[:enrolled_in] = SchoolUnit.where(id:user.school_unit_id)[0].description 
    else 
      elastic_data[:enrolled_in] = nil 
    end
    Symptom.all.each do |symptom|
      elastic_data[symptom.description] = self.symptom.include? symptom.description
    end
    return elastic_data 
  end

  private

  def get_top_3_syndromes
    syndrome_list = []
    syndromes = Syndrome.all
    syndromes.each do |syndrome|
      new_syndrome = {
        syndrome: syndrome,
        likelyhood: get_syndrome_score(syndrome)
      }
      syndrome_list.append(new_syndrome)
    end
    syndrome_list = syndrome_list.sort_by { |syndrome| syndrome[:likelyhood] }.reverse
    syndrome_list = syndrome_list.select { |syndrome| syndrome[:likelyhood] > 0 }
    return syndrome_list[0..2]
  end

  # Calculated with positive predictive value
  # https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values
  def get_syndrome_score(syndrome)
    sum = 0
    modulus_division = 0
    syndrome.symptoms.each do |symptom|
      percentage = SyndromeSymptomPercentage.where(symptom:symptom, syndrome:syndrome)[0]
      if percentage
        if @user_symptoms.include?(symptom)
            sum += percentage.percentage
        end
        modulus_division += percentage.percentage
      end
    end
    if modulus_division == 0
      return 0
    else
      return sum/modulus_division
    end
  end

  def get_symptoms_messages
    messages = []
    @user_symptoms.each do |symptom|
      unless symptom.message.nil?
        messages.append(symptom.message)
      end
    end
    return messages
  end
end
