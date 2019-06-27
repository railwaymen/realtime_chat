# frozen_string_literal: true

module RoomMessagesConcern
  extend ActiveSupport::Concern

  included do
    private

    def broadcast_message(message, type)
      if message.room.public?
        AppChannel.broadcast_to('app', data: message.serialized, type: type)
      else
        message.room.rooms_users.includes(:user).each do |rooms_user|
          UserChannel.broadcast_to(rooms_user.user, data: message.serialized, type: type)
        end
      end
    end
  end
end
