# frozen_string_literal: true

module Api
  module V1
    class RoomsController < Api::V1::BaseController
      include RoomsConcern
      before_action :authenticate_user!

      def index
        @rooms = policy_scope(Room).kept
        render json: Api::V1::RoomSerializer.render(@rooms), status: 200
      end

      def create
        @room = current_user.rooms.build(create_room_params)

        if @room.save
          AppChannel.broadcast_to('app', data: @room.serialized, type: :room_create)
          create_rooms_user_for_owner!(@room) if @room.public == false

          render json: @room.serialized, status: 200
        else
          render json: Api::V1::ErrorSerializer.render_as_hash(@room), status: 422
        end
      end

      def update
        @room = Room.kept.find(params[:id])
        authorize @room
        
        if @room.update(update_room_params)
          AppChannel.broadcast_to('app', data: @room.serialized, type: :room_update)
          render json: @room.serialized, status: 200
        else
          render json: Api::V1::ErrorSerializer.render_as_hash(@room), status: 422
        end
      end

      def destroy
        @room = Room.kept.find(params[:id])
        authorize @room

        @room.discard

        AppChannel.broadcast_to('app', data: @room.serialized, type: :room_destroy)
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
