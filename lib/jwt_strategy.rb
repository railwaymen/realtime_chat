# frozen_string_literal: true

module Devise
  module Strategies
    class JwtStrategy < Base
      def valid?
        token.present?
      end

      def authenticate!
        payload = JwtService.decode token: token
        success! User.find_by!(id: payload['id'], authentication_token: token)
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        fail! 'incorrect token'
      end

      def store?
        false
      end

      def token
        request.headers['Token']
      end
    end
  end
end
