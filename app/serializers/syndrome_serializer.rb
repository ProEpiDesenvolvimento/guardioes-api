class SyndromeSerializer < ActiveModel::Serializer
  attributes :id, :description, :details

  has_one :message
  has_many :symptoms

  def symptoms
    return object.symptoms.map do |symptom|
      obj = symptom.as_json({only: [:description]})
      if SyndromeSymptomPercentage.where(syndrome:object,symptom:symptom).any?
        syndrome_symptom_percentage = SyndromeSymptomPercentage.where(syndrome:object,symptom:symptom)[0]
        obj[:percentage] = syndrome_symptom_percentage.percentage
        obj[:ponderation] = syndrome_symptom_percentage.ponderation
      else
        obj[:percentage] = 0
        obj[:ponderation] = 0
      end
      obj
    end
  end
end
