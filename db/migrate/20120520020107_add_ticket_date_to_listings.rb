class AddTicketDateToListings < ActiveRecord::Migration
  def change
    add_column :listings, :ticket_date, :datetime
  end
end