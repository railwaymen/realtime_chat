class CreateJoinTableRoomsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :rooms, :users do |t|
      t.timestamps
    end

    add_index :rooms_users, [:room_id, :user_id], unique: true
  end
end
