class AddTwitterIdTouser < ActiveRecord::Migration
  def change
    add_column :users, :tw_id, :integer
  end
end
