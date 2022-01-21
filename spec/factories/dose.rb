FactoryBot.define do 
  factory :dose do 
      date { '2022-01-01' }
      dose { 2 }
      user { association  :user }
      vaccine { association :vaccine }
  end
end