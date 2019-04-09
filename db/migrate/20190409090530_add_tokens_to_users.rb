class AddTokensToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :refresh_token, :string
  end
end
