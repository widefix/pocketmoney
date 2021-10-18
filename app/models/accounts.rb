class Accounts
  class << self
    extend Memoist

    delegate :each, to: :all

    memoize def all
      Transaction.distinct.pluck(:from_account) | Transaction.distinct.pluck(:to_account)
    end
  end
end
