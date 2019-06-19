class AddPublicToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :public, :boolean, default: true, null: false
  end
end
