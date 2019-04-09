# frozen_string_literal: true

module Api
  module V1
    class AuthenticationsController < BaseController
      def create
        @sign_in_form = SignInForm.new(email: params[:email], password: params[:password])
        @sign_in_form.save
        respond_with @sign_in_form
      end

      def refresh
        @user = User.find_by(authentication_token: request.headers['Token'], refresh_token: params[:token])
        head(:unauthorized) && return unless @user
        @user.generate_authentication_token
        @user.save!
        respond_with @user
      end
    end
  end
end
