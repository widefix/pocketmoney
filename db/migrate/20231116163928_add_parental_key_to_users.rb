# frozen_string_literal: true

class AddParentalKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :parental_key, :string
    add_index :users, :parental_key, unique: true
    add_column :users, :blocked_at, :datetime
  end
end
