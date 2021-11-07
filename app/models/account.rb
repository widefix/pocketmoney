class Account < ApplicationRecord
  has_many :income_transactions, class_name: 'Transaction', foreign_key: :to_account_id
  has_many :outcome_transactions, class_name: 'Transaction', foreign_key: :from_account_id
  has_many :children, class_name: 'Account', foreign_key: :parent_id

  belongs_to :parent, class_name: 'Account', optional: true

  memoize def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end
end
