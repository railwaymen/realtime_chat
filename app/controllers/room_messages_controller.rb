class RoomMessagesController < BaseController
  def create
    room = Room.kept.find params.dig(:room_message, :room_id)
    @message = room.messages.build(message_params.merge(user: current_user))
    authorize @message

    @message.save

    RoomChannel.broadcast_to(room, type: :create, data: message_representation) if @message.valid?
  end

  def update
    @message = RoomMessage.find params[:id]
    authorize @message

    @message.update(message_params)

    RoomChannel.broadcast_to(@message.room, type: :update, data: message_representation) if @message.valid?
  end

  def destroy
    @message = current_user.messages.includes(:room).find params[:id]
    @message.discard

    RoomChannel.broadcast_to(@message.room, type: :destroy, data: message_representation)
  end

  private

  def message_params
    params.require(:room_message).permit(:body)
  end

  def message_representation
    json = ApplicationController.renderer.render(
      partial: 'api/v1/messages/message',
      locals: {
        message: @message,
        current_user: current_user
      }
    )

    JSON.parse(json)
  end
end
