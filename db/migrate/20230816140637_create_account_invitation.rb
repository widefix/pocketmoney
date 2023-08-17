class CreateAccountInvitation < ActiveRecord::Migration[6.1]
  def change
    create_table :account_invitation do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :name
      t.string :token
      t.references :account, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
    add_index :account_invitation, :token
  end
end
