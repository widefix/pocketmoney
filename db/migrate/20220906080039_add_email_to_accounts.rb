class AddEmailToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :email, :string, default: "", null: false
    add_column :accounts, :notification, :boolean, default: false
  end
end
