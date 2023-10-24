FactoryBot.define do
  factory :account do
    trait :with_notify do
      name { FFaker::Name.first_name }
      email { FFaker::Internet.email }
      notification { true }
    end

    trait :parent do
      name { FFaker::Name.first_name }
      email { FFaker::Internet.email }
    end

    trait :children do
      name { FFaker::Name.first_name }
      email { FFaker::Internet.email }
    end

    trait :store do
      name { 'store' }
    end
  end
end
