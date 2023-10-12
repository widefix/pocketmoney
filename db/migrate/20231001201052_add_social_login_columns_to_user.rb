# frozen_string_literal: true

class AddSocialLoginColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :avatar_url, :string
    add_column :users, :provider, :string
  end
end
