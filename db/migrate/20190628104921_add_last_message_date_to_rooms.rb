class AddLastMessageDateToRooms < ActiveRecord::Migration[5.2]
  def up
    add_column :rooms, :last_message_at, :datetime

    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE FUNCTION update_rooms_last_message_at() RETURNS TRIGGER AS
      $$
        BEGIN
          UPDATE rooms SET last_message_at = new.created_at WHERE id = new.room_id;
          RETURN new;
        END
      $$
      LANGUAGE plpgsql;

      CREATE TRIGGER update_rooms_last_message_at_trigger AFTER INSERT ON room_messages
      FOR EACH ROW EXECUTE PROCEDURE update_rooms_last_message_at();
    SQL

    Room.all.each do |room|
      last_message = room.messages.order(created_at: :desc).first
      room.update_column(:last_message_at, last_message.created_at) if last_message.present?
    end
  end

  def down
    ActiveRecord::Base.connection.execute(<<-SQL)
      DROP TRIGGER update_rooms_last_message_at_trigger ON room_messages;
      DROP FUNCTION update_rooms_last_message_at();
    SQL

    remove_column :rooms, :last_message_at
  end
end
