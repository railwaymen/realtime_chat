# frozen_string_literal: true

module Api
  module V1
    class RoomsController < Api::V1::BaseController
      include RoomsConcern
      before_action :authenticate_user!

      def index
        @rooms = policy_scope(Room).kept
        respond_with @rooms
      end

      def create
        @room = current_user.rooms.create(create_room_params)
        if @room.valid?
          AppChannel.broadcast_to('app', data: @room, type: :room_create)
          create_rooms_user_for_owner!(@room) if @room.public == false
        end
        respond_with @room
      end

      def update
        @room = Room.kept.find(params[:id])
        authorize @room

        @room.update(update_room_params)
        AppChannel.broadcast_to('app', data: @room, type: :room_update) if @room.valid?
        respond_with @room
      end

      def destroy
        @room = Room.kept.find(params[:id])
        authorize @room

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
