module RoomMessagesConcern
  extend ActiveSupport::Concern

  included do
    private

    def broadcast_message(message, type)
      if message.room.public?
        RoomChannel.broadcast_to('app', data: message, type: type)
      else
        message.room.rooms_users.includes(:user).each do |rooms_user|
          UserChannel.broadcast_to(rooms_user.user, data: message, type: type)
        end
      end
    end
  end
end
