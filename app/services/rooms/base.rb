# frozen_string_literal: true

module Rooms
  class Base
    def initialize(room_params:, user_ids: [], user:, room: nil)
      @room_params = room_params
      @user = user
      @user_ids = process_user_ids(user_ids)
      @room = room
    end

    private

    def process_user_ids(ids)
      ids.is_a?(String) ? ids.split(',').map(&:to_i) : ids
    end
  end
end
