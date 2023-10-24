class TransactionsController < ApplicationController
  def show; end

  def destroy
    transaction = Transaction.find(ps.fetch(:id)) # TODO: implement authorization
    transaction.destroy
    if transaction.to_account.name == 'store'
      redirect_to account_path(transaction.from_account)
    else
      redirect_to account_path(transaction.to_account)
    end
  end

  helper_method memoize def transaction
    Transaction.find(ps.fetch(:id))
  end
end
