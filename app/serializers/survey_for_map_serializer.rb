class SurveyForMapSerializer < ActiveModel::Serializer
    attributes :id, :latitude, :longitude, :symptom

    def attributes(*args)
        h = super(*args)
        coordinates = Survey.new(h).get_anonymous_latitude_longitude
        h[:latitude] = coordinates[:latitude]
        h[:longitude] = coordinates[:longitude]
        h
    end
end  