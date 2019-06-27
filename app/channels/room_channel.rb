# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.kept.find params[:room_id]
    stream_for room
  end

  def user_typing(data)
    @room = Room.kept.find data['room_id']

    RoomChannel.broadcast_to(
      @room,
      message: :typing,
      typing: data['typing'],
      user: {
        id: current_user.id,
        username: current_user.username
      }
    )
  end
end
