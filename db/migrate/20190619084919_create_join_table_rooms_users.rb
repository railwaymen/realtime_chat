class CreateJoinTableRoomsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms_users do |t|
      t.belongs_to :room, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.timestamps
    end

    add_index :rooms_users, [:room_id, :user_id], unique: true
  end
end
