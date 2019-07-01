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
      @room = user.rooms.create(create_room_params)
    end

    def create_rooms_users
      return true if room.public?

      users_ids = params.fetch(:users_ids, []).push(user.id)

      users_ids.map do |user_id|
        room.rooms_users.create!(user_id: user_id)
      end
    end

    def create_room_params
      params.require(:room).permit(:name, :public)
    end
  end
end
