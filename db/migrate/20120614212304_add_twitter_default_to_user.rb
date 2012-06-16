class AddTwitterDefaultToUser < ActiveRecord::Migration
  def change
    add_column :users, :tw_default, :boolean
    add_column :users, :fb_default, :boolean
  end
end
