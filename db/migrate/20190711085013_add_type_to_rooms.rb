class AddTypeToRooms < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE room_type AS ENUM ('open', 'closed', 'direct');
    SQL

    add_column :rooms, :type, :room_type

    Room.where(public: true).update_all(type: :open)
    Room.where(public: false).update_all(type: :closed)

    remove_column :rooms, :public
    change_column_null :rooms, :type, false
  end

  def down
    add_column :rooms, :public, :boolean, default: true

    Room.update_all("public = (type = 'open')")

    remove_column :rooms, :type

    execute <<-SQL
      DROP TYPE room_type;
    SQL

    change_column_null :rooms, :public, false
  end
end
