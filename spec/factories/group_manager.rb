FactoryBot.define do
    factory :group_manager do
      email { Faker::Internet.email }
      password { "12345678" }
      vigilance_syndromes { [] }
    end
end