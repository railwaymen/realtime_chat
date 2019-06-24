class AddDiscardedAtToRoomMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :room_messages, :discarded_at, :datetime
    add_index :room_messages, :discarded_at
  end
end
