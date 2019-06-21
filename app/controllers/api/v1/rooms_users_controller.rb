# frozen_string_literal: true

module Api
  module V1
    class RoomsUsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        @rooms_users = room.rooms_users.includes(:user)
        respond_with @rooms_users
      end

      def create
        @rooms_user = room.rooms_users.create(rooms_user_params)
        respond_with @rooms_user
      end

      def destroy
        user_rooms_ids = current_user.rooms.ids
        @rooms_user = RoomsUser.where(room_id: user_rooms_ids).find(params[:id])
        @rooms_user.destroy!
        head :no_content
      end

      private

      def room
        @room ||= current_user.rooms.find(params[:room_id])
      end

      def rooms_user_params
        params.permit(:user_id)
      end
    end
  end
end
