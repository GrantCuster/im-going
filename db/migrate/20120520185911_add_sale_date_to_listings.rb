class AddSaleDateToListings < ActiveRecord::Migration
  def change
    add_column :listings, :sale_date, :datetime
  end
end
