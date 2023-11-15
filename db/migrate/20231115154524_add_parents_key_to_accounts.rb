# frozen_string_literal: true

class AddParentsKeyToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :parents_key, :integer, null: true
    add_index :accounts, :parents_key, unique: true
  end
end
