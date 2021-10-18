class Account
  extend Dry::Initializer
  extend Memoist

  param :name

  memoize def balance
    Transaction.where(to_account: name).sum(:amount) -
      Transaction.where(from_account: name).sum(:amount)
  end
end
