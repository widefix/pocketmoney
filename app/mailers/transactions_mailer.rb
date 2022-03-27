class TransactionsMailer < ApplicationMailer
  def automatic_top_up_done(transaction)
    @to_account = transaction.to_account
    @amount = transaction.amount
    @user = transaction.from_account.user
    prevent_delivery and return unless @user

    mail to: @user.email
  end
end
