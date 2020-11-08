FactoryBot.define do
    factory :admin do
      email { Faker::Internet.email }
      password { "12345678" }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      is_god { true }
      app { FactoryBot.create(:app)}
    end
end