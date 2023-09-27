# frozen_string_literal: true

class AddArchivedToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :archived_at, :datetime
  end
end
