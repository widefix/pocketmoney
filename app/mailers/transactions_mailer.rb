class TransactionsMailer < ApplicationMailer
  def automatic_top_up_done(transaction)
    @to_account = transaction.to_account
    @amount = transaction.amount
    @user = transaction.from_account.user
    prevent_delivery and return unless @user

    mail to: @user.email, title: "Automatic top up account - #{@to_account.name}"
  end

  def transaction_notification(account)
    @account = account
    @transaction = Transaction.last
    @from_account = @transaction.from_account.name
    mail to: @account.email, subject: "Success! Transaction added." 
  end
end
