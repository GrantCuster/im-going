class AddIntentions < ActiveRecord::Migration
  def change
    create_table :intentions do |t|
      t.integer :intention
      t.integer :user_id

      t.timestamps
    end
  end
end
