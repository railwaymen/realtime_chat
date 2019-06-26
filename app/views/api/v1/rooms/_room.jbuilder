# frozen_string_literal: true

json.extract! room, :id, :name, :channel_name, :user_id, :public
json.editable room.owner?(current_user)

json.room_path room_path(room)
