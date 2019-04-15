class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find params[:room]
    stream_for room
  end

  def user_typing(data)
    @room = Room.find data['room_id']
    RoomChannel.broadcast_to @room, message: :typing, typing: data['typing'], user: { id: current_user.id, username: current_user.username }
  end
end