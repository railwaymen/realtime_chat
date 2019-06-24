# frozen_string_literal: true

json.extract! rooms_user, :id, :user_id, :room_id
json.user do
  json.partial! 'api/v1/users/user', user: rooms_user.user
end
