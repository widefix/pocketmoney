# frozen_string_literal: true

FactoryBot.define do
  factory :account_automatic_topup_config do
    association :from_account, factory: :account
    association :to_account, factory: :account
    amount { FFaker::Number.number }
  end
end
