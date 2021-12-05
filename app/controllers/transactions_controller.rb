class TransactionsController < ApplicationController
  def destroy
    transaction = Transaction.find(ps.fetch(:id))
    transaction.destroy
    redirect_back(fallback_location: account_path(transaction.to_account))
  end
end
