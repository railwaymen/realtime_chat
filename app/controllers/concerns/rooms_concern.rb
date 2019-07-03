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
  end
end
