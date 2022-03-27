class AutomaticTopupAction < ApplicationAction
  option :from
  option :to
  option :amount

  private

  def perform_implementation
    transaction = Transaction.create!(
      from_account: from,
      to_account: to,
      amount: amount
    )
    TransactionsMailer.automatic_top_up_done(transaction).deliver_now
  end
end
