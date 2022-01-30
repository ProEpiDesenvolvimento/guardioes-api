FactoryBot.define do
  factory :category do
    name { 'Teste' }
    description { 'descrição' }
    user { association :user }
  end
end