# frozen_string_literal: true

module Api
  module V1
    class AuthenticationsController < Api::V1::BaseController
      def create
        @sign_in_form = SignInForm.new(email: params[:email], password: params[:password])
        @sign_in_form.save

        render json: Api::V1::AuthenticationSerializer.render(@sign_in_form.user, view: :auth), status: 200
      end

      def refresh
        @user = User.find_by(authentication_token: request.headers['Token'], refresh_token: params[:token])
        head(:unauthorized) && return unless @user
        @user.generate_authentication_token
        @user.save!

        render json: Api::V1::AuthenticationSerializer.render(@user, view: :refresh), status: 200
      end
    end
  end
end
