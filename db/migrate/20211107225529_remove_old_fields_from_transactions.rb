class RemoveOldFieldsFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :from_account
    remove_column :transactions, :to_account
  end
end
