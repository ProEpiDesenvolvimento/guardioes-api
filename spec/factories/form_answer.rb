FactoryBot.define do
    factory :form_answer do
      form_id { Faker::Number.number(10) }
      form_question_id { Faker::Number.number(10) }
      form_option_id { Faker::Number.number(10) }
      user_id { association :user }
    end
end