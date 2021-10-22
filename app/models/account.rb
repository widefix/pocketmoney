class Account
  extend Dry::Initializer
  extend Memoist

  param :name

  memoize def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end

  memoize def income_transactions
    Transaction.where(to_account: name)
  end

  memoize def outcome_transactions
    Transaction.where(from_account: name)
  end
end
