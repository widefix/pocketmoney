# frozen_string_literal: true

class AddParentalKeyToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :parental_key, :string
    add_index :accounts, :parental_key, unique: true
  end
end
