class AddUserAccountRelation < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :accounts, foreign_key: true, index: true
  end
end
