class RenameUserAccountsId < ActiveRecord::Migration[6.1]
  def change
    rename_column(:users, :accounts_id, :account_id)
  end
end
