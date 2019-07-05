# frozen_string_literal: true

module Api
  module V1
    class RoomSerializer < Blueprinter::Base
      identifier :id

      fields :name, :description, :channel_name, :public, :user_id, :last_message_at

      field :deleted do |room, _options|
        room.discarded?
      end

      field :participants_ids do |room, _options|
        room.rooms_users.pluck(:user_id)
      end

      field :room_path do |room, _options|
        Rails.application.routes.url_helpers.room_path(room)
      end
    end
  end
end
