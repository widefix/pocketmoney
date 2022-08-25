FactoryBot.define do
  factory :account do
    trait :parent do
      name { FFaker::Name.first_name }
    end

    trait :children do
      name { FFaker::Name.first_name }
    end
  end
end