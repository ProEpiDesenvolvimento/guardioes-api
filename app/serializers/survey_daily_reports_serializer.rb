class SurveyDailyReportsSerializer < ActiveModel::Serializer
    attributes :id, :symptom, :created_at, :bad_since

    has_one :household
end
  
