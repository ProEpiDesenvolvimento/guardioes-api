class RumorSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :confirmed_cases, :confirmed_deaths

    has_one :app
  end
  