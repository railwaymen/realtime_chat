# frozen_string_literal: true

json.array! @messages do |message|
  json.partial! 'message', message: message
end
