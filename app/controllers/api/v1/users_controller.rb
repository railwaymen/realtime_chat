# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        @users = User.all
        respond_with @users
      end
    end
  end
end
