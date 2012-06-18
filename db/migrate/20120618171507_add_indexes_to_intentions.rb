class AddIndexesToIntentions < ActiveRecord::Migration
  def change
    add_index :intentions, :user_id
    add_index :intentions, :listing_id
    add_index :intentions, [:user_id, :listing_id], unique: true
  end
end
