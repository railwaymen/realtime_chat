# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      User.find_by(id: cookies.signed['user.id']) ||
        User.find_by(authentication_token: request.headers['Token']) ||
        reject_unauthorized_connection
    end
  end
end
