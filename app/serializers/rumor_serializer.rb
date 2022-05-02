class RumorSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :confirmed_cases, :confirmed_deaths,
               :latitude, :longitude, :created_at, :updated_at

    has_one :app
  end
  