FactoryBot.define do
  factory :group_manager do
    email { Faker::Internet.email }
    password { "12345678" }
    name { Faker::Name.first_name }
    group_name { Faker::Team.name }
    twitter { Faker::Name.first_name  }
    app_id { FactoryBot.create(:app)}
  end
end