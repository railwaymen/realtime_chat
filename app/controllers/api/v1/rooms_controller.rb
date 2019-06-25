# frozen_string_literal: true

module Api
  module V1
    class RoomsController < Api::V1::BaseController
      before_action :authenticate_user!
      
      def index
        private_rooms_ids = current_user.rooms_users.pluck(:room_id)
        @rooms = Room.kept.where('public = true OR id IN (?)', private_rooms_ids)
        respond_with @rooms
      end

      def create
        @room = current_user.rooms.create(create_room_params)
        AppChannel.broadcast_to('app', data: @room, type: :room_create) if @room.valid?
        respond_with @room
      end

      def update
        @room = current_user.rooms.find(params[:id])
        @room.update(update_room_params)
        AppChannel.broadcast_to('app', data: @room, type: :room_update) if @room.valid?
        respond_with @room
      end

      def destroy
        @room = current_user.rooms.find(params[:id])
        @room.discard
        AppChannel.broadcast_to('app', data: @room, type: :room_destroy)
        RoomChannel.broadcast_to(@room, type: :room_close)
        head :no_content
      end

      private

      def create_room_params
        params.permit(:name, :public)
      end

      def update_room_params
        params.permit(:name)
      end
    end
  end
end
