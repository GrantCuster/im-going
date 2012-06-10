class AddTwitterSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tw_secret, :string
  end
end