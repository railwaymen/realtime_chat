class AddDescriptionToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :description, :text
  end
end
