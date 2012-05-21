class AddDateTimeToListing < ActiveRecord::Migration
  def change
    add_column :listings, :date_and_time, :datetime
  end
end
