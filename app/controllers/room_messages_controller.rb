class RoomMessagesController < BaseController
  before_action :load_entities

  def create
    @room_message = RoomMessage.create user: current_user,
                                       room: @room,
                                       body: params.dig(:room_message, :body)
    RoomChannel.broadcast_to @room, @room_message
  end

  private

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
