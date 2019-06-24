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
        @rooms_user = room.rooms_users.build(rooms_user_params)
        authorize @rooms_user

        @rooms_user.save
        respond_with @rooms_user
      end

      def destroy
        @rooms_user = RoomsUser.find(params[:id])
        authorize @rooms_user

        @rooms_user.destroy!
        head :no_content
      end

      private

      def room
        @room ||= policy_scope(Room).kept.find(params[:room_id])
      end

      def rooms_user_params
        params.permit(:user_id)
      end
    end
  end
end
