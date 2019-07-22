# frozen_string_literal: true

module Rooms
  class Base
    def initialize(room_params:, users_ids: '', user:, room: nil)
      @room_params = room_params
      @user = user
      @users_ids = users_ids.split(',').map(&:to_i)
      @room = room
    end
  end
end
