class TransactionsController < ApplicationController
  def destroy
    transaction = Transaction.find(ps.fetch(:id)) # TODO: implement authorization
    transaction.destroy
    redirect_back(fallback_location: account_path(transaction.to_account))
  end
end
