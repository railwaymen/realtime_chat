# frozen_string_literal: true

json.array! @rooms do |room|
  json.partial! 'room', room: room
end
