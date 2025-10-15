FactoryBot.define do
  factory :flexible_form_version do
    version { 1 }
    notes { "Test version" }
    data { '{"questions": [{"field": "test", "text": "Test question"}]}' }
    version_date { DateTime.now }
    flexible_form { association :flexible_form }
  end
end
