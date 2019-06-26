# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        @users = User.all
        render json: Api::V1::UserSerializer.render_as_hash(@users), status: 200
      end
    end
  end
end
