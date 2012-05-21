class RemoveTicketDateToListings < ActiveRecord::Migration
  def change
    remove_column :listings, :ticket_date, :datetime
  end
end