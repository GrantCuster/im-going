class AddListingIdToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :listing_id, :integer
  end
end
