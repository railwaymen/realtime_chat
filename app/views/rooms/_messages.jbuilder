# frozen_string_literal: true
json.room_id @room.id
json.current_user_id current_user.id

json.messages @messages do |message|
  json.extract! message, :id, :user_id, :body, :updated_at, :created_at

  json.user do
    json.username message.user.username
  end
end
