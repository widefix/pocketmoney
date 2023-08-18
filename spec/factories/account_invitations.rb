FactoryBot.define do
  factory :account_invitation do
    association :user, factory: :user
    name { FFaker::Name.first_name }
    email { FFaker::Internet.email }
    token { FFaker::Lorem.phrase }
    association :account, factory: %i[account parent]
  end
end
