class RumorSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :confirmed_cases, :confirmed_deaths,
               :latitude, :longitude, :created_at, :updated_at

    belongs_to :user
    belongs_to :app
  end
  