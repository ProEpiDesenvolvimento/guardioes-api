class Survey < ApplicationRecord
  acts_as_paranoid
  # Index name for a survey is now:
  # classname_environment[if survey user has group, _groupmanagergroupname]
  # For these changes to take effect, a reindex of the entire database is needed
  # Don't touch searchkick's functionalities before reading the comment on
  # the search_data function, in this file.
  searchkick index_name: 'trash_data'

  belongs_to :user
  belongs_to :household, optional:true
  before_validation :reverse_geocode

  serialize :symptom, Array

  def address
    [street, city, state, country].compact.join(', ')
  end
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
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
    # READ THIS BEFORE TOUCHING THE FOLLOWING IF CONDITION

    # The following is a solution to dynamically assign index names (during runtime)
    # THE SOLUTION IS A HACK. Working with the library searchkick was not an option because it does  
    # not provide a way to select during object create and update runtime the name of the index we 
    # want to send the data to. The workaroud is to run the indexing twice in the following way:

    # Pre-condition: In searchkick's module inclusion, up there ^^, index name is set as 'trash_data'
    # and @reindex_control is NOT true
    
    # 1. The first time though, @reindex_control will be not true, therefore it enter the if below
    # 2. Now we set searchkick's static index name variable as the name we want
    # 3. We now set @reindex_control as true
    # 4. We call reindex and during reindexing, the program loop comes right back to this function
    # 5. Now the reindexing is running and @@searchkick_index has the index name we want
    # 6. We set the index to the "standard" name of 'trash_data' and @reindex_control to false,  
    #    thus fulfilling the pre-condition for further object use
    # 7. Reindex has ended, we now send to the index 'trash_data' the empty object {}

    # This solution is terrible but I could not think of a better one as of now
    # If you want to solve this better, read searchkick's source code: github.com/ankane/searchkick

    if @reindex_control != true
      @@searchkick_index = index_pattern_name
      @reindex_control = true
      self.reindex
      return {}
    else
      @@searchkick_index = 'trash_data'
      @reindex_control = false
    end

    # End of hack

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
    if !user.group.nil?
      elastic_data[:group] = user.group.get_path(string_only=true, labeled=false).join('/') 
    else 
      elastic_data[:group] = nil 
    end
    Symptom.all.each do |symptom|
      elastic_data[symptom.description] = self.symptom.include? symptom.description
    end
    return elastic_data 
  end

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
