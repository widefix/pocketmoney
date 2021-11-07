class Account < ApplicationRecord
  has_many :income_transactions, class_name: 'Transaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'Transaction', foreign_key: :from_account_id

  memoize def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end
end
