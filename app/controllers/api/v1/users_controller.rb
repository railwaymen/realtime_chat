# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        @users = User.all
        render json: Api::V1::UserSerializer.render_as_hash(@users), status: 200
      end

      def profile
        render json: Api::V1::CurrentUserSerializer.render_as_hash(current_user), status: 200
      end

      def update
        if current_user.update(message_params)
          render json: current_user.serialized, status: 200
        else
          render json: Api::V1::ErrorSerializer.render_as_hash(current_user), status: 422
        end
      end

      private

      def message_params
        params.permit(:avatar)
      end
    end
  end
end
