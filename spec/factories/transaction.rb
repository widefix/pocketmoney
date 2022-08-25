FactoryBot.define do
  factory :transaction do
    amount { FFaker::Number.number }
    description { FFaker::Lorem.phrase }
  end
end