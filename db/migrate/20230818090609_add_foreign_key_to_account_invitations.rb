class AddForeignKeyToAccountInvitations < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :account_invitations, :accounts, on_delete: :cascade
    add_foreign_key :account_invitations, :users, on_delete: :cascade
  end
end
