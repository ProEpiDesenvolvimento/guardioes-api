class SurveyForMapSerializer < ActiveModel::Serializer
    attributes :id, :latitude, :longitude, :symptom
end  