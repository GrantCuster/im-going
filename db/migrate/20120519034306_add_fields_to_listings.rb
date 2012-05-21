class AddFieldsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :intention, :integer
    add_column :listings, :venue_address, :string
    add_column :listings, :event_description, :text
    add_column :listings, :ticket_option, :integer
    add_column :listings, :sell_out, :integer
    add_column :listings, :cost, :string
    add_column :listings, :ticket_url, :text
  end
end