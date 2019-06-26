# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < Blueprinter::Base
      identifier :id

      fields :username, :email
    end
  end
end
