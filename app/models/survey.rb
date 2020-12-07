# frozen_string_literal: true

class Survey < ApplicationRecord
  acts_as_paranoid
  searchkick unless Rails.env.test?

  # Index name for a survey is now:
  # classname_environment[if survey user has group, _groupmanagergroupname]
  # It has been overriden searchkick's class that sends data to elaticsearch,
  # such that the index name is now defined by the model that is being
  # evaluated using the function 'index_pattern_name'
  def index_pattern_name
    env = ENV['RAILS_ENV']
    return "surveys_#{env}" if user.group.nil?

    group_name = user.group.group_manager.group_name
    group_name.downcase!
    group_name.gsub! ' ', '-'
    "surveys_#{env}_#{group_name}"
  end

  belongs_to :user
  belongs_to :household, optional: true
  before_validation :reverse_geocode

  serialize :symptom, Array

  def address
    [street, city, state, country].compact.join(', ')
  end

  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city    = geo.city
      obj.country = geo.country
      obj.street  = geo.street
      obj.state   = geo.state
    end
  end

  def get_message(user)
    @user_symptoms = []
    symptom.map do |symptom|
      @user_symptoms.append(Symptom.where(description: symptom)[0]) if Symptom.where(description: symptom).any?
    end
    symptoms_and_syndromes_data = {}
    symptom_messages = get_symptoms_messages
    symptoms_and_syndromes_data[:symptom_messages] = symptom_messages if symptom_messages.any?
    top_3 = get_top_3_syndromes
    if top_3.any?
      symptoms_and_syndromes_data[:top_3] = top_3.map do |obj|
        # Possible COVID case detected, send mail to active vigilance about case
        if obj[:syndrome].description == 'Síndrome Gripal' && user.is_vigilance == true
          VigilanceMailer.covid_vigilance_email(self, user).deliver
        end

        { name: obj[:syndrome].description, percentage: obj[:likelyhood] }
      end

      syndrome_message = top_3[0][:syndrome].message
      symptoms_and_syndromes_data[:top_syndrome_message] = syndrome_message || '' unless syndrome_message.nil?
    end

    symptoms_and_syndromes_data
  end

  scope :filter_by_user, ->(user) { where(user_id: user) }

  # Data that gets sent as fields for elastic indexes
  def search_data
    # Set current user/household in variable user
    user = nil
    user = if !household_id.nil?
             Household.find(household_id)
           else
             self.user
           end

    # Get object data as hash off of json
    elastic_data = as_json(except: [:updated_at])

    # Add user group. If group is not present and school unit is, add school unit description
    elastic_data[:group] = if !user.group.nil?
                             user.group.get_path(string_only = true, labeled = false).join('/')
                           elsif !user.school_unit_id.nil?
                             SchoolUnit.find(user.school_unit_id).description
                           end

    # Add symptoms by column of booleans
    Symptom.all.each do |symptom|
      elastic_data[symptom.description] = self.symptom.include? symptom.description
    end

    # Add user's city, state, country,
    # birthdate, if she is part of the risk group for COVID,
    # race, gender
    elastic_data['gender'] = user.gender
    elastic_data['race'] = user.race
    elastic_data['user_city'] = user.instance_of?(User) ? user.city : nil
    elastic_data['user_state'] = user.instance_of?(User) ? user.state : nil
    elastic_data['user_country'] = user.country
    elastic_data['birthdate'] = user.birthdate
    elastic_data['risk_group'] = user.risk_group || false

    elastic_data
  end

  def csv_data
    data = as_json(except: %i[updated_at latitude longitude
                              bad_since symptom street city
                              state country deleted_at traveled_to
                              contact_with_symptom went_to_hospital])
    data[:user_name] = user.user_name
    data[:user_created_at] = user.created_at
    data[:identification_code] = user.identification_code
    data[:household_identification_code] = nil
    data[:household_created_at] = nil
    data[:household_name] = nil
    data[:household_identification_code] = household.identification_code if household
    data[:household_created_at] = household.created_at if household
    data[:household_name] = household.description if household
    data
  end

  # this function will not be used anymore, because the offset of
  # the location is not wanted anymore, but it will be here if someone
  # needs one day
  def get_anonymous_latitude_longitude
    # This offsets a survey positioning randomly by, at most, 50 meters, so as to "anonymize" data
    return { latitude: nil, longitude: nil } if latitude.nil? || longitude.nil?

    ret = {}
    dx = 0.05 * rand # latitude  offset in kilometers (up to 50 meters)
    dy = 0.05 * rand # longitude offset in kilometers (up to 50 meters)
    r_earth = 6378 # Earth radius in kilometers
    pi = Math::PI

    ret[:latitude]  = latitude + (dx / r_earth) * (180.0 / pi)
    ret[:longitude] = longitude + (dy / r_earth) * (180.0 / pi) / Math.cos(latitude * pi / 180.0)

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
    syndrome_list = syndrome_list.select { |syndrome| (syndrome[:likelyhood]).positive? }
    syndrome_list[0..2]
  end

  # Calculated with positive predictive value
  # https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values
  def get_syndrome_score(syndrome)
    sum = 0
    modulus_division = 0
    syndrome.symptoms.each do |symptom|
      percentage = SyndromeSymptomPercentage.where(symptom: symptom, syndrome: syndrome)[0]
      next unless percentage

      sum += percentage.percentage if @user_symptoms.include?(symptom)
      modulus_division += percentage.percentage
    end
    if modulus_division.zero?
      0
    else
      sum / modulus_division
    end
  end

  def get_symptoms_messages
    messages = []
    @user_symptoms.each do |symptom|
      messages.append(symptom.message) unless symptom.message.nil?
    end
    messages
  end
end
