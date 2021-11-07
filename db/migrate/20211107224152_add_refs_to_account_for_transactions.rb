class AddRefsToAccountForTransactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :to_account, foreign_key: {to_table: :accounts}
    add_reference :transactions, :from_account, foreign_key: {to_table: :accounts}
  end
end
