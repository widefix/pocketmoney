class TransactionsController < ApplicationController
  def show; end

  def destroy
    transaction = Transaction.find(ps.fetch(:id)) # TODO: implement authorization
    transaction.destroy
    redirect_to account_path(transaction.to_account)
  end

  helper_method memoize def transaction
    Transaction.find(ps.fetch(:id))
  end
end
