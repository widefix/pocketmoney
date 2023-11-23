# frozen_string_literal: true

class AddParentalKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :parental_key, :string
    add_index :users, :parental_key, unique: true
  end
end
