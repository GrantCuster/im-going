class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :listing_name
      t.integer :user_id

      t.timestamps
    end
  end

end
