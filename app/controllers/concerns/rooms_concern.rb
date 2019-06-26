module RoomsConcern
  extend ActiveSupport::Concern

  included do
    private

    def create_rooms_user_for_owner!(room)
      RoomsUser.create!(room_id: room.id, user_id: current_user.id)
    end
  end
end
