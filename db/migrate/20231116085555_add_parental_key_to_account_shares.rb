# frozen_string_literal: true

class AddParentalKeyToAccountShares < ActiveRecord::Migration[6.1]
  def change
    add_column :account_shares, :parental_key, :string
  end
end
