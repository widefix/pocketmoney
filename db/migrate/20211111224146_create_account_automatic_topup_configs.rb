class CreateAccountAutomaticTopupConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :account_automatic_topup_configs do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.belongs_to :from_account, foreign_key: {to_table: :accounts}, null: false
      t.belongs_to :to_account, foreign_key: {to_table: :accounts}, null: false
      t.timestamps
    end
  end
end
