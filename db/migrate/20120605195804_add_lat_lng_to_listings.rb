class AddLatLngToListings < ActiveRecord::Migration
  def change
    add_column :listings, :lat, :bigint
    add_column :listings, :lng, :bigint
  end
end