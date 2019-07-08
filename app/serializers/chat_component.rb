# frozen_string_literal: true

class ChatComponent < Blueprinter::Base
  field :room_id do |room, _options|
    room.id
  end

  field :is_accessible do |room, options|
    room.public? || room.rooms_users.where(user_id: options[:current_user]&.id).exists?
  end

  field :current_user_id do |_room, options|
    options[:current_user]&.id
  end

  association :messages, blueprint: Api::V1::MessageSerializer do |_room, options|
    options[:messages]
  end
end
