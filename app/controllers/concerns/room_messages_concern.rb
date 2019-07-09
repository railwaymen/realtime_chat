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

    def assign_attachments(message, ids)
      attachments = policy_scope(Attachment).where(id: ids)
      attachments.update_all(room_message_id: message.id, updated_at: Time.current)
    end
  end
end
