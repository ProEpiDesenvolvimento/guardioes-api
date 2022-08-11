FactoryBot.define do
    factory :form do
      group_manager_id { association :group_manager }
    end
end