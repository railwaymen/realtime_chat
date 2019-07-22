# frozen_string_literal: true

module Rooms
  class Updater < Base
    def call
      ActiveRecord::Base.transaction do
        update_room

        if @room.valid?
          update_rooms_users
          broadcast_room_message
        end
      end

      @room
    end

    private

    def update_room
      @room.update(@room_params)
    end

    def separate_rooms_users
      current_users = @room.users.where.not(id: @user.id)
      new_users = User.where(id: @users_ids)

      @users_groups = {
        deleted: current_users - new_users,
        added: new_users - current_users
      }
    end

    def update_rooms_users
      return if @room.open?

      separate_rooms_users

      # Remove users
      deleted_users_ids = @users_groups[:deleted].map(&:id)
      @room.rooms_users.where(user_id: deleted_users_ids).destroy_all

      # Add users
      @users_groups[:added].map do |user|
        @room.rooms_users.create!(user_id: user.id)
      end
    end

    def broadcast_room_message
      if @room.open?
        AppChannel.broadcast_to('app', data: @room.serialized, type: :room_update)
      else
        @users_groups[:added].map do |user|
          UserChannel.broadcast_to(user, data: @room.serialized, type: :room_open)
        end

        @users_groups[:deleted].map do |user|
          UserChannel.broadcast_to(user, data: @room.serialized, type: :room_close)
        end
      end
    end
  end
end
