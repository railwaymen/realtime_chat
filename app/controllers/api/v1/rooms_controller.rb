# frozen_string_literal: true

module Api
  module V1
    class RoomsController < Api::V1::BaseController
      before_action :authenticate_user!
      
      def index
        @rooms = Room.all
        respond_with @rooms
      end

      def create
        @room = current_user.rooms.create(room_params)
        respond_with @room
      end

      def update
        @room = current_user.rooms.find(params[:id])
        @room.update(room_params)
        respond_with @room
      end

      def destroy
        @room = current_user.rooms.find(params[:id])
        @room.destroy!
        respond_with @room
      end

      private

      def room_params
        params.permit(:name)
      end
    end
  end
end
