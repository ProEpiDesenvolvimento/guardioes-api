FactoryBot.define do 
  factory :vaccine do 
      name { 'Vacina' }
      laboratory { 'laboratorio' }
      doses { 2 }
      max_dose_interval { 10 }
      min_dose_interval { 1 }
      country_origin { 'Brasil' }
      app { association :app }
  end
end