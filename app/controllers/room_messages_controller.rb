class RoomMessagesController < BaseController
  def create
    room = Room.kept.find params.dig(:room_message, :room_id)
    @room_message = RoomMessage.create user: current_user,
                                       room: room,
                                       body: params.dig(:room_message, :body)
    RoomChannel.broadcast_to room, type: :create, data: message_representation
  end

  private

  def message_representation
    json = ApplicationController.renderer.render(partial: 'api/v1/messages/message', locals: { message: @room_message, current_user: current_user })
    JSON.parse(json)
  end
end
