# frozen_string_literal: true

class AddParentalKeyToUsersAndAccountShares < ActiveRecord::Migration[6.1]
  def change
    add_column :account_shares, :parental_key, :string
    add_column :users, :parental_key, :string
    add_index :account_shares, :parental_key
    add_index :users, :parental_key
  end
end
