class AddRoomsActivityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rooms_activity, :jsonb, null: false, default: {}
  end
end
