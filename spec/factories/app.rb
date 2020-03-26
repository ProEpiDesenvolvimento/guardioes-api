FactoryBot.define do
  factory :app do
    app_name { Faker::Company.name }
    owner_country { Faker::Address.country }
  end
end