class MigrateTransactions < ActiveRecord::Migration[6.1]
  def change
    Transaction.find_each do |transaction|
      acc_from = Account.find_by!(name: transaction.read_attribute(:from_account))
      acc_to = Account.find_by!(name: transaction.read_attribute(:to_account))
      transaction.update!(from_account_id: acc_from.id, to_account_id: acc_to.id)
    end
  end
end
