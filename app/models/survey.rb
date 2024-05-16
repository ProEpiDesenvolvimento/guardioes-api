class Survey < ApplicationRecord
  acts_as_paranoid
  require 'net/http'
  require 'httparty'

  belongs_to :user
  belongs_to :household, optional:true
  before_validation :reverse_geocode

  serialize :symptom, Array

  def address
    [street, city, state, country].compact.join(', ')
  end
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    geo = results.first
    if !geo.data['error']
      obj.city        = geo.city
      obj.country     = geo.country
      obj.street      = geo.street
      obj.state       = geo.state
      obj.postal_code = geo.postal_code
    end
  end

  scope :filter_by_user, ->(user) { where(user_id: user) }

  # Data that gets sent as fields
  def search_data
    # Set current user/household in variable user
    user = nil
    if !self.household_id.nil?
      user = Household.find(self.household_id)
    else
      user = self.user
    end

    # Get object data as hash off of json
    data = self.as_json(except: [:updated_at]) 
    
    # Add user group. If group is not present and school unit is, add school unit description
    if !user.group.nil?
      data[:group] = user.group.get_path(string_only=true, labeled=false).join('/') 
    else
      data[:group] = nil 
    end
    
    # Add symptoms by column of booleans
    Symptom.all.each do |symptom|
      data[symptom.description] = self.symptom.include? symptom.description
    end
    
    # Add user's city, state, country, 
    # birthdate, if she is part of the risk group for COVID,
    # race, gender
    data["gender"] = user.gender 
    data["race"] = user.race 
    data["user_city"] = user.class == User ? user.city : nil
    data["user_state"] = user.class == User ? user.state : nil
    data["user_country"] = user.country
    data["birthdate"] = user.birthdate
    data["risk_group"] = user.risk_group || false
    
    return data 
  end

  def get_syndromes_data(user)
    symptoms_and_syndromes_data = {}

    @survey_symptoms = []
    symptom.each do |s|
      symptom = Symptom.where(:code => s)
      if symptom.any?
        @survey_symptoms.append(symptom.first)
      end
    end
    
    symptom_messages = get_symptoms_messages
    if symptom_messages.any?
      symptoms_and_syndromes_data[:symptom_messages] = symptom_messages
    end

    top_3_syndromes = get_top_3_syndromes
    if top_3_syndromes.any?
      symptoms_and_syndromes_data[:top_3] = top_3_syndromes.map do |obj|
        { name: obj[:syndrome].description, percentage: obj[:likelyhood] }
      end

      match_synd = top_3_syndromes.first
      date = DateTime.now.utc.beginning_of_day - match_synd[:syndrome].days_period.days

      syndrome_message = match_synd[:syndrome].message
      if !syndrome_message.nil?
        symptoms_and_syndromes_data[:top_syndrome_message] = syndrome_message
      end

      reported = false

      if user.group_id
        group = Group.find_by(id: user.group_id)
        group_manager = GroupManager.find_by(id: group.group_manager_id)

        if user.is_vigilance == true and group_manager[:vigilance_syndromes].any?
          group_manager[:vigilance_syndromes].each do |vigilance_synd|
            if vigilance_synd[:syndrome_id] == match_synd[:syndrome].id
              if self.household_id == nil
                token = auth_go_data(group_manager)

                if !token.nil? and vigilance_synd[:surto_id]
                  user_cases = get_user_cases_go_data(token, date, vigilance_synd, group_manager)

                  if !is_user_already_on_case_go_data(user_cases, date)
                    self.update_attribute(:syndrome_id, match_synd[:syndrome].id)
                    VigilanceMailer.vigilance_email(self, user, match_synd[:syndrome]).deliver
                    report_go_data(token, user_cases, vigilance_synd, group_manager)
                    reported = true
                  end
                end
              end

              if !reported
                user_cases = get_user_cases_database(user, date, match_synd)
                
                if !user_cases.any?
                  self.update_attribute(:syndrome_id, match_synd[:syndrome].id)
                  VigilanceMailer.vigilance_email(self, user, match_synd[:syndrome]).deliver
                  reported = true
                end
              end
              # break loop after match syndrome is found
              break
            end
          end
        end
      end
      
      if !reported
        user_cases = get_user_cases_database(user, date, match_synd)
   
        if !user_cases.any?
          self.update_attribute(:syndrome_id, match_synd[:syndrome].id)
          reported = true
        end
      end
    end
    
    return symptoms_and_syndromes_data
  end

  def get_user_cases_database(user, date, match_synd)
    cases = Survey.filter_by_user(user.id).where("created_at >= ?", date)
              .where(syndrome_id: match_synd[:syndrome].id)
              .where(household: self.household)
    return cases
  end

  def get_user_cases_go_data(token, date, vigilance_syndrome, group_manager)
    # Get user related cases on GO.Data and do a filter
    query = {"where": {"and": [{"visualId": {"regexp": "/^GDS_#{self.user.id.to_s}/i"}}]}}
    uri = URI("#{group_manager.url_godata}/api/outbreaks/#{vigilance_syndrome[:surto_id]}/cases?filter=#{query.to_json}")
    res = HTTParty.get(uri, headers: { Authorization: 'Bearer ' + token })

    cases = JSON.parse(res.body)
    return cases.select { |c|
      c['visualId'][/^GDS_#{self.user.id.to_s}_.*|^GDS_#{self.user.id.to_s}\b/i]
    }
  end

  def is_user_already_on_case_go_data(user_cases, date)
    # Check if user has already a confirmed/pending case on GO.Data
    cases_discarted_label = "LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_NOT_A_CASE_DISCARDED"
    cases_discarted_label2 = "LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_DESCARTADO"

    cases_on_period = user_cases.select { |c| 
      DateTime.parse(c['dateOfOnset']) > date && 
      c['classification'] != cases_discarted_label &&
      c['classification'] != cases_discarted_label2
    }

    if cases_on_period.blank?
      return false
    end
    return true
  end

  def report_go_data(token, user_cases, vigilance_syndrome, group_manager)
    # Check user reocurrence to syndrome to generate a unique visualID
    visualID = "GDS_" + self.user.id.to_s

    if !user_cases.blank?
      last_user_case = user_cases.last
      last_user_case_name = last_user_case['visualId']
      case_count_string = last_user_case_name.split('_')[2]

      if !case_count_string.nil?
        counter = case_count_string.to_i + 1
        visualID += "_" + counter.to_s
      else
        visualID += "_2"
      end
    end

    # Creating case's data
    age = ((Time.zone.now - self.user.birthdate.to_time) / 1.year.seconds).floor
    races = {
      'Branco' => '1',
      'Indígena' => '2',
      'Pardo' => '3',
      'Preto' => '4',
      'Amarelo' => '5'
    }

    symptoms = {
      'Tosse' => '2',
      'Febre' => '3',
      'DorCabeca' => '4',
      'paladareolfato' => '5',
      'Bolhasna Pele' => '6',
      'Calafrios' => '7',
      'Cansaco' => '8',
      'Coceira' => '9',
      'CongestãoNasal' => '10',
      'Diarreia' => '11',
      'DificuldadeParaRespirar' => '12',
      'DorDeEstômago' => '13',
      'DordeGarganta' => '14',
      'DorNasArticulações' => '15',
      'DorNosMúsculos' => '16',
      'DorNosOlhos' => '17',
      'InguaOuGângliosInflamados' => '18',
      'Mal-estar' => '19',
      'ManchasRoxasPeloCorpo' => '20',
      'NáuseaOuVômito' => '21',
      'PeleEOlhosAmarelados' => '22',
      'Sangramento' => '23'
    }

    genders = {
      'Mulher Cis' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_FEMALE',
      'Homem Cis' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_MALE',
      'Mulher Trans' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_MULHER_TRANS',
      'Homem Trans' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_HOMEM_TRANS',
      'Não-binárie' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_NAO_BINARIE',
      'Masculino' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_MALE',
      'Feminino' => 'LNG_REFERENCE_DATA_CATEGORY_GENDER_FEMALE'
    }

    caseData = {
      'firstName' => self.user.user_name.split(" ")[0],
      'gender' => genders[self.user.gender],
      'isDateOfOnsetApproximate' => self.bad_since == nil ? true : false,
      'classification' => "LNG_REFERENCE_DATA_CATEGORY_CASE_CLASSIFICATION_SUSPECT",
      'pregnancyStatus' => 'LNG_REFERENCE_DATA_CATEGORY_PREGNANCY_STATUS_NONE',
      'outbreakId' => vigilance_syndrome[:surto_id],
      'visualId' => visualID,
      'dob' => self.user.birthdate,
      'age' => {
        'years': age,
      },
      'dateOfReporting' => DateTime.now,
      'dateOfOnset' => self.bad_since != nil ? self.bad_since : DateTime.now
    }

    if self.user.group
      if self.user.group.location_id_godata == nil
        if self.user.group.group_manager_id == 4
          group_location_id = "8101b71b-dbaa-4d3e-b585-459513c1f23a"   
        elsif self.user.group.group_manager_id == 7
          group_location_id = "a3e632e3-3955-4f45-978a-4e835204420c"
        end
      else
        group_location_id = self.user.group.location_id_godata
      end

      caseData['addresses'] = [
        {
          "typeId": "LNG_REFERENCE_DATA_CATEGORY_ADDRESS_TYPE_USUAL_PLACE_OF_RESIDENCE",
          "country": 'Brasil',
          "city": self.user.city,
          #"addressLine1": self.user.group.description,
          #"postalCode": '70910-900', #Nao posuimos CEP em nossos cadastros
          "locationId": group_location_id,
          "geoLocationAccurate": false,
          "date": self.created_at,
          "phoneNumber": self.user.phone,
          "emailAddress": self.user.email
        }
      ]
    end

    if self.user.user_name.split(" ").length > 1
      caseData['lastName'] = self.user.user_name.split(" ").last
    end

    # QuestionnaireAnswers
    caseData['questionnaireAnswers'] = {
      'raca_cor' => [
        {
          'value' => races[self.user.race]
        }
      ],
      'profissional_da_saude' => [
        {
          'value' => self.user.is_professional == true ? '1' : '2'
        }
      ],
      'se_foi_ao_hospital' => [
        {
          'value' => self.went_to_hospital != nil ? '1' : '2'
        }
      ],
      'se_esteve_na_instituicao_nos_ultimos_14_dias' => [
        {
          'value' => self.traveled_to != nil ? '1' : '2'
        }
      ],
      'se_teve_contato_com_alguem_com_os_mesmos_sintomas' => [
        {
          'value' => self.contact_with_symptom != nil ? '1' : '2'
        }
      ],
    }

    # case's symptoms
    if self.symptom.any?
      caseData['questionnaireAnswers']['sintomas'] = [{}]
      caseData['questionnaireAnswers']['sintomas'][0]['value'] = []
      self.symptom.each do |s|
        caseData['questionnaireAnswers']['sintomas'][0]['value'].append(symptoms[s])
      end
    else
      caseData['questionnaireAnswers']['sintomas'] = [{'value': '1'}]
    end

    # Active Outbreak before report case
    uri = URI("#{group_manager.url_godata}/api/users/#{group_manager.userid_godata}")
    res = HTTParty.patch(uri, body: {activeOutbreakId: vigilance_syndrome[:surto_id]}, headers: { Authorization: 'Bearer ' + token })

    # Report case
    uri = URI("#{group_manager.url_godata}/api/outbreaks/#{vigilance_syndrome[:surto_id]}/cases")
    res = HTTParty.post(uri, body: caseData, headers: { Authorization: 'Bearer ' + token })
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
    # This offsets a survey positioning randomly by, at most, 106 meters, and at least, 70 meters, so as to "anonymize" data
    if self.latitude == nil || self.longitude == nil
      return { latitude: nil, longitude: nil }
    end
    
    ret = {}
    dx = 0.1 * rand(0.5..0.75) # latitude  offset in kilometers (up to 75 meters)
    dy = 0.1 * rand(0.5..0.75) # longitude offset in kilometers (up to 75 meters)
    r_earth = 6378     # Earth radius in kilometers
    pi = Math::PI

    ret[:latitude]  = self.latitude + (dx / r_earth) * (180.0 / pi)
    ret[:longitude] = self.longitude + (dy / r_earth) * (180.0 / pi) / Math.cos(latitude * pi/180.0)

    ret
  end

  private

  def auth_go_data(group_manager)
    # Login on GO.Data API
    begin 
      crypt = ActiveSupport::MessageEncryptor.new(ENV['GODATA_KEY'])
      password_godata = crypt.decrypt_and_verify(group_manager.password_godata)
    rescue
    end
    uri = URI("#{group_manager.url_godata}/api/oauth/token")
    res = HTTParty.post(uri, body: { username: group_manager.username_godata, password: password_godata })
    if (res.code != 200)
      return nil
    end
    return JSON.parse(res.body.gsub('=>', ':'))['access_token']
  end

  def get_top_3_syndromes
    syndrome_list = []
    syndromes = Syndrome.all
    syndromes.each do |syndrome|
      new_syndrome = {
        syndrome: syndrome,
        likelyhood: get_syndrome_score(syndrome)
      }
      if new_syndrome[:likelyhood] < syndrome.threshold_score
        next
      end
      syndrome_list.append(new_syndrome)
    end
    syndrome_list = syndrome_list.sort_by { |syndrome| syndrome[:likelyhood] }.reverse
    return syndrome_list[0..2]
  end

  # Calculated with positive predictive value
  # https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values
  def get_syndrome_score(syndrome)
    sum = 0
    modulus_division = 0
    syndrome.symptoms.each do |symptom|
      percentage = SyndromeSymptomPercentage.where(symptom:symptom, syndrome:syndrome).first
      if percentage
        if @survey_symptoms.include?(symptom)
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
    @survey_symptoms.each do |symptom|
      unless symptom.message.nil?
        messages.append(symptom.message)
      end
    end
    return messages
  end
end
