class AddAcceptedAtToAccountInvitation < ActiveRecord::Migration[6.1]
  def change
    rename_table :account_invitation, :account_invitations
    add_column :account_invitations, :accepted_at, :datetime
    remove_column :account_invitations, :status, :integer
  end
end
