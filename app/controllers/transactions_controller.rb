class TransactionsController < ApplicationController
  def destroy
    transaction = Transaction.find(params.fetch(:id))
    transaction.destroy
    redirect_back(fallback_location: account_path(transaction.to_account))
  end
end
