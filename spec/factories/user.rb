FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { "12345678" }
      user_name { Faker::Name.name }
      email { Faker::Internet.email }
      birthdate { Faker::Date.birthday(18, 65) }
      country { Faker::Address.country }
      gender { Faker::Gender.type }
      race { "human" }
      is_professional { false }
      app { App.all.first }
    end
end