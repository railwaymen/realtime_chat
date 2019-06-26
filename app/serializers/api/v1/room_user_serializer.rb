module Api
  module V1
    class RoomUserSerializer < Blueprinter::Base
      identifier :id

      fields :user_id, :room_id

      association :user, blueprint: Api::V1::UserSerializer
    end
  end
end