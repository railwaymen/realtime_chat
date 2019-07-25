# frozen_string_literal: true

module Rooms
  class Creator < Base
    def call
      ActiveRecord::Base.transaction do
        extend_user_ids
        create_room

        if @room.valid?
          create_rooms_users
          broadcast_room_message
        end
      end

      @room
    end

    private

    def extend_user_ids
      @user_ids.unshift(@user.id).uniq
    end

    def create_room
      assign_room_name if @room_params[:type] == 'direct'
      @room = @user.rooms.create(@room_params)
    end

    def assign_room_name
      @room_params['name'] = "__direct_room_#{@user_ids.sort.join('_')}"
    end

    def create_rooms_users
      return if @room.open?

      @user_ids.map do |user_id|
        @room.rooms_users.create!(user_id: user_id)
      end
    end

    def broadcast_room_message
      if @room.open?
        AppChannel.broadcast_to('app', data: @room.serialized, type: :room_create)
      else
        @room.users.map do |user|
          UserChannel.broadcast_to(user, data: @room.serialized, type: :room_create)
        end
      end
    end
  end
end
