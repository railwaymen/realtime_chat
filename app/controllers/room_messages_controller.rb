class RoomMessagesController < BaseController
  def create
    room = Room.find params.dig(:room_message, :room_id)
    @room_message = RoomMessage.create user: current_user,
                                       room: room,
                                       body: params.dig(:room_message, :body)
    RoomChannel.broadcast_to room, type: :create, data: message_representation(@room_message)
  end

  private

  def message_representation(message)
    message.slice(:id, :user_id, :body, :updated_at, :created_at).merge(user: { username: message.user.username })
  end
end
