# frozen_string_literal: true

json.room_id @room.id
json.current_user_id current_user.id

json.messages @messages do |message|
  json.partial! 'api/v1/messages/message', message: message
end
