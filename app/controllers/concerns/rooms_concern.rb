# frozen_string_literal: true

module RoomsConcern
  extend ActiveSupport::Concern

  included do
    def update_activity
      room = Room.kept.find(params[:id])
      authorize room

      current_user.update_room_activity(room)
      head :no_content
    end

    private

    def create_rooms_user_for_owner!(room)
      RoomsUser.create!(room_id: room.id, user_id: current_user.id)
    end
  end
end
