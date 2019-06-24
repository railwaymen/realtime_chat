# frozen_string_literal: true

json.array! @rooms_users do |rooms_user|
  json.partial! 'rooms_user', rooms_user: rooms_user
end
