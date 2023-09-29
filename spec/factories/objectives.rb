# frozen_string_literal: true

FactoryBot.define do
  factory :objective do
    name { FFaker::Book.title }
    amount { FFaker::Number.number }
    association :account, factory: %i[account parent]
  end
end
