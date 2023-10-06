# frozen_string_literal: true

class AutomaticTopupAction < ApplicationAction
  option :from
  option :to
  option :amount

  private

  def perform_implementation
    return if existing_transaction

    transaction = Transaction.new(
      from_account: from,
      to_account: to,
      amount: amount,
      description: 'Automatic Top-up'
    )

    return unless transaction.valid?

    transaction.save
    TransactionsMailer.automatic_top_up_done(transaction).deliver_now
  end

  def existing_transaction
    Transaction.find_by(
      from_account: from,
      to_account: to,
      amount: amount,
      description: 'Automatic Top-up',
      created_at: Date.current.beginning_of_day..Date.current.end_of_day
    )
  end
end
