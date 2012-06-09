class AddTwitterTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :tw_token, :string
  end
end
