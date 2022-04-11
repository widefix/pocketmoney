class CreateObjectives < ActiveRecord::Migration[6.1]
  def change
    create_table :objectives do |t|
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.belongs_to :account, foreign_key: true
      t.string :image_url
      t.timestamps
    end
  end
end
