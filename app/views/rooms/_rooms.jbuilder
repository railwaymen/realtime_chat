# frozen_string_literal: true

json.current_user_id current_user.id

json.rooms @rooms do |room|
  json.partial! 'api/v1/rooms/room', room: room
end
