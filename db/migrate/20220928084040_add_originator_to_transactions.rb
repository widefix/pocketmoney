class AddOriginatorToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :originator, foreign_key: {to_table: :users}
  end
end
