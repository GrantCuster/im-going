class AddPrivacyToListings < ActiveRecord::Migration
  def change
    add_column :listings, :privacy, :integer
  end
end