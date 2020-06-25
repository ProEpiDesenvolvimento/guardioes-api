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
    top_3 = get_top_3_syndromes
    @symdromes = Syndrome.all
    @symptoms = Symptom.all
    message = {
      :top_3 => get_top_3_syndromes.map { |syndrome| { name: syndrome.syndrome.name, percentage: symdom.likelyhood }},
      :top_syndrome_message => get_top_3_syndromes[0].syndrome.message,
      :symptom_messages => get_symptoms_messages
    }
  end
 
  scope :filter_by_user, ->(user) { where(user_id: user) }
 
  private

  def get_top_3_syndromes
    syndrome_list = []
    @syndromes.each do {|syndrome|
      syndrome_list.append({
        :syndrome => syndrome,
        :likelyhood => get_syndrome_score(syndrome)
      })
    }
    syndrome_list.sort_by { |syndrome| syndrome.likelyhood }.reverse
    return symdrom_list[0..3]
  end

  def get_symdrom_score(symdrom)
    sum = 0
    syndrome.symptom.each do { |symptom|
      if @user_symptoms.include?(symptom)
        sum += symptom.syndrome_symptom_percentage.percentage
      end
    }
    return sum
  end

  def get_symptoms_messages
    messages = []
    @user_symptoms.each do { |symptom|
      if @symptoms[:symptom].message
        messages.append(@symptoms[:symptom].message)
      end
    }
    return messages
  end
end
