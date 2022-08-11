FactoryBot.define do
    factory :form_option do
        value { Faker::Lorem.sentence }
        text { Faker::Lorem.sentence }
        order { Faker::Number.number(10) }
        form_question_id { association :form_question }
    end
end