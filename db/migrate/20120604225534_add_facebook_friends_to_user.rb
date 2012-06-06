class AddFacebookFriendsToUser < ActiveRecord::Migration
  def change
    add_column :users, :fb_friends, :text
  end
end