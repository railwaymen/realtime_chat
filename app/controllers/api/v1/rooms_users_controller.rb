# frozen_string_literal: true

module Api
  module V1
    class RoomsUsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        @rooms_users = room.rooms_users.includes(:user)
        render json: Api::V1::RoomUserSerializer.render_as_hash(@rooms_users), status: 200
      end

      def create
        @rooms_user = room.rooms_users.build(rooms_user_params)
        authorize @rooms_user

        @rooms_user.save!
        render json: @rooms_user.serialized, status: 200
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
