# frozen_string_literal: true

module Rooms
  class Base
    def initialize(room_params:, users_ids: '', user: nil, room: nil)
      @room_params = room_params
      @users_ids = users_ids.split(',').map(&:to_i)
      @user = user
      @room = room
    end
  end
end
