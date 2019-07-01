# frozen_string_literal: true

module Rooms
  class Base
    attr_reader :params, :user, :room

    def initialize(params:, user:)
      @params = params
      @user = user
    end

    private

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
