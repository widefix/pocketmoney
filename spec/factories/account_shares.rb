# frozen_string_literal: true

FactoryBot.define do
  factory :account_share do
    association :user, factory: :user
    name { FFaker::Name.first_name }
    email { FFaker::Internet.email }
    token { SecureRandom.urlsafe_base64(32) }
    association :account, factory: %i[account parent]
  end
end
