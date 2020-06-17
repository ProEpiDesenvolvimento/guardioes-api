class SurveyDailyReportsSerializer < ActiveModel::Serializer
    attributes :id, :symptom, :created_at

    has_one :household
end
  