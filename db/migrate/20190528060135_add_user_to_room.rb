class AddUserToRoom < ActiveRecord::Migration[5.2]
  def change
    rename_column :room_messages, :message, :body
    add_reference :rooms, :user, foreign_key: true

    Room.find_each do |room|
      room.update! user: User.order('random()').first
    end

    change_column_null :rooms, :user_id, false
  end
end
