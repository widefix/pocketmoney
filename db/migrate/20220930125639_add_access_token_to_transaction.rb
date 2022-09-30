class AddAccessTokenToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :access_token, :string
  end
end
