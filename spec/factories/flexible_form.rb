FactoryBot.define do
  factory :flexible_form do
    title { "Test Quiz" }
    description { "Test quiz description" }
    form_type { "quiz" }
    app { association :app }
    group_manager_id { nil }
  end
end
