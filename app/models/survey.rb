class Survey < ApplicationRecord
  acts_as_paranoid
  if !Rails.env.test?
    searchkick
  end
    
  # Index name for a survey is now:
  # classname_environment[if survey user has group, _groupmanagergroupname]
  # It has been overriden searchkick's class that sends data to elaticsearch, 
  # such that the index name is now defined by the model that is being 
  # evaluated using the function 'index_pattern_name'  
  def index_pattern_name
    env = ENV['RAILS_ENV']
    if self.user.group.nil?
      return 'surveys_' + env
    end
    group_name = self.user.group.group_manager.group_name
    group_name.downcase!
    group_name.gsub! ' ', '-'
    return 'surveys_' + env + '_' + group_name
  end

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
  
  def get_message(user)
    @user_symptoms = []
    symptom.map { |symptom|
      if Symptom.where(:code=>symptom).any?
        @user_symptoms.append(Symptom.where(:code=>symptom)[0])
      end
    }
    symptoms_and_syndromes_data = {}
    symptom_messages = get_symptoms_messages
    if symptom_messages.any?
      symptoms_and_syndromes_data[:symptom_messages] = symptom_messages
    end
    top_3 = get_top_3_syndromes
    if top_3.any?
      symptoms_and_syndromes_data[:top_3] = top_3.map do |obj| 
        # Possible COVID case detected, send mail to active vigilance about case
        if obj[:syndrome].description == "Síndrome Gripal" && user.is_vigilance == true
          VigilanceMailer.covid_vigilance_email(self, user).deliver
        end
        
        { name: obj[:syndrome].description, percentage: obj[:likelyhood] }
      end

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
    # Set current user/household in variable user
    user = nil
    if !self.household_id.nil?
      user = Household.find(self.household_id)
    else
      user = self.user
    end

    # Get object data as hash off of json
    elastic_data = self.as_json(except: [:updated_at]) 
    
    # Add user group. If group is not present and school unit is, add school unit description
    if !user.group.nil?
      elastic_data[:group] = user.group.get_path(string_only=true, labeled=false).join('/') 
    elsif !user.school_unit_id.nil?
      elastic_data[:group] = SchoolUnit.find(user.school_unit_id).description
    else
      elastic_data[:group] = nil 
    end
    
    # Add symptoms by column of booleans
    Symptom.all.each do |symptom|
      elastic_data[symptom.description] = self.symptom.include? symptom.description
    end
    
    # Add user's city, state, country, 
    # birthdate, if she is part of the risk group for COVID,
    # race, gender
    elastic_data["gender"] = user.gender 
    elastic_data["race"] = user.race 
    elastic_data["user_city"] = user.class == User ? user.city : nil
    elastic_data["user_state"] = user.class == User ? user.state : nil
    elastic_data["user_country"] = user.country
    elastic_data["birthdate"] = user.birthdate
    elastic_data["risk_group"] = user.risk_group || false
    
    return elastic_data 
  end

  def csv_data
    data = self.as_json(except: [ :updated_at, :latitude, :longitude, 
                                  :bad_since, :symptom, :street, :city, 
                                  :state, :country, :deleted_at, :traveled_to, 
                                  :contact_with_symptom, :went_to_hospital]) 
    data[:user_name] = self.user.user_name
    data[:user_created_at] = self.user.created_at
    data[:identification_code] = self.user.identification_code
    data[:household_identification_code] = nil
    data[:household_created_at] = nil
    data[:household_name] = nil
    data[:household_identification_code] = self.household.identification_code if self.household
    data[:household_created_at] = self.household.created_at if self.household
    data[:household_name] = self.household.description if self.household
    data
  end
  
  # this function will not be used anymore, because the offset of
  # the location is not wanted anymore, but it will be here if someone
  # needs one day
  def get_anonymous_latitude_longitude
    # This offsets a survey positioning randomly by, at most, 50 meters, so as to "anonymize" data
    if self.latitude == nil || self.longitude == nil
      return { latitude: nil, longitude: nil }
    end
    
    ret = {}
    dx = 0.05 * rand() # latitude  offset in kilometers (up to 50 meters)
    dy = 0.05 * rand() # longitude offset in kilometers (up to 50 meters)
    r_earth = 6378     # Earth radius in kilometers
    pi = Math::PI

    ret[:latitude]  = self.latitude + (dx / r_earth) * (180.0 / pi)
    ret[:longitude] = self.longitude + (dy / r_earth) * (180.0 / pi) / Math.cos(latitude * pi/180.0)

    ret
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
