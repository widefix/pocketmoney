class AddParentToAccount < ActiveRecord::Migration[6.1]
  def change
    add_reference :accounts, :parent, foreign_key: {to_table: :accounts}, index: true
  end
end
