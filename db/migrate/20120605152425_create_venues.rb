class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :venue_name
      t.string :venue_address
      t.text :venue_url
      t.integer :user_id

      t.timestamps
    end
  end
end
