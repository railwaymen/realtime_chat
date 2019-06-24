# frozen_string_literal: true

json.array! @rooms do |room|
  json.partial! 'api/v1/rooms/room', room: room
end
