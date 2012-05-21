class AddVenueInformationToListings < ActiveRecord::Migration
  def change
    add_column :listings, :venue_name, :string
    add_column :listings, :venue_url, :string   
  end
end