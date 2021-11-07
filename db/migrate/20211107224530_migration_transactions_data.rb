class MigrationTransactionsData < ActiveRecord::Migration[6.1]
  def change
    Accounts.each do |name|
      Account.create!(name: name)
    end
  end
end
