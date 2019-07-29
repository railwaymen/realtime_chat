# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < Blueprinter::Base
      identifier :id

      fields :username, :email

      field :avatar_url do |user, _options|
        user.avatar.thumb.url
      end
    end
  end
end
