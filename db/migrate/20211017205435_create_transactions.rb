class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :from_account, null: false
      t.string :to_account, null: false
      t.timestamps
    end
  end
end
