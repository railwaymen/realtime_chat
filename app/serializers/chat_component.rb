# frozen_string_literal: true

class ChatComponent < Blueprinter::Base
  field :room_id do |room, _options|
    room.id
  end

  field :room_deleted do |room, _options|
    room.discarded?
  end

  field :current_user_id do |_room, options|
    options[:current_user]&.id
  end

  association :messages, blueprint: Api::V1::MessageSerializer do |_room, options|
    options[:messages]
  end
end
