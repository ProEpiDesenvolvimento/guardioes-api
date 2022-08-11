FactoryBot.define do
    factory :form_question do
      kind { "text" }
      text { Faker::Lorem.sentence }
      order { Faker::Number.number(10) }
      form_id { association :form }
    end
end