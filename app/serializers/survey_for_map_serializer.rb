class SurveyForMapSerializer < ActiveModel::Serializer
    attributes :id, :latitude, :longitude, :symptom

    def attributes(*args)
        h = super(*args)
        coordinates = Survey.new(h).get_anonymous_latitude_longitude
        print h[:latitude].to_s, h[:longitude].to_s, '\n'
        h[:latitude] = coordinates[:latitude]
        h[:longitude] = coordinates[:longitude]
        print h[:latitude].to_s, h[:longitude].to_s, '\n'
        h
    end
end  