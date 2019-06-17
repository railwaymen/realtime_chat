class AddDiscardedAtToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :discarded_at, :datetime
    add_index :rooms, :discarded_at
  end
end
