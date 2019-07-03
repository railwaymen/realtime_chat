# frozen_string_literal: true

module Rooms
  class Creator < Base
    def call
      ActiveRecord::Base.transaction do
        create_room

        room.valid? &&
          create_rooms_users &&
          broadcast_room_message
      end

      room
    end

    private

    def create_room
      @room = user.rooms.create(room_params)
    end

    def create_rooms_users
      return true if room.public?

      users_ids.unshift(user.id) unless user.nil?

      users_ids.map do |user_id|
        room.rooms_users.create!(user_id: user_id)
      end
    end

    def broadcast_room_message
      if room.public?
        AppChannel.broadcast_to('app', data: room.serialized, type: :room_create)
      else
        room.users.map do |user|
          UserChannel.broadcast_to(user, data: room.serialized, type: :room_create)
        end
      end
    end
  end
end
