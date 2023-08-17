class RemoveIndexesFromAccountInvitations < ActiveRecord::Migration[6.1]
  def change
    remove_index :account_invitations, name: "index_account_invitations_on_account_id"
    remove_index :account_invitations, name: "index_account_invitations_on_token"
    remove_index :account_invitations, name: "index_account_invitations_on_user_id"

    remove_foreign_key :account_invitations, column: "account_id"
    remove_foreign_key :account_invitations, column: "user_id"
  end
end
