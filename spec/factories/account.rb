FactoryBot.define do
  factory :account do
    trait :parent do
      name { FFaker::Name.first_name }
      email { FFaker::Internet.email }
    end

    trait :children do
      name { FFaker::Name.first_name }
      email { FFaker::Internet.email }
    end
  end
end