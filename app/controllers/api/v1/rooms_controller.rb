# frozen_string_literal: true

module Api
  module V1
    class RoomsController < BaseController
      before_action :authenticate_user!
      
      def index
        @rooms = Room.all
        respond_with @rooms
      end

      def create
        @room = Room.create(room_params)
        respond_with @room
      end

      def update
        @room = Room.find(params[:id])
        @room.update(room_params)
        respond_with @room
      end

      def destroy
        @room = Room.find(params[:id])
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
