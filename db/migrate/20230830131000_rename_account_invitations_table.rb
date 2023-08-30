# frozen_string_literal: true

class RenameAccountInvitationsTable < ActiveRecord::Migration[6.1]
  def change
    rename_table :account_invitations, :account_shares
  end
end
