# frozen_string_literal: true

class RoomMessagesController < BaseController
  include RoomMessagesConcern

  def load_more
    @room = Room.kept.find(params[:room_id])
    authorize @room, :show?

    messages = @room.messages
                    .includes(:user, :attachments)
                    .where('id < ?', params[:last_id])
                    .order(id: :desc)
                    .limit(params[:limit])
                    .reverse

    render json: Api::V1::MessageSerializer.render(messages), status: 200
  end

  def create
    room = Room.kept.find params.dig(:room_message, :room_id)
    @message = room.messages.build(message_params.merge(user: current_user))
    authorize @message

    return unless @message.save

    assign_attachments(@message, params[:attachment_ids]) if params[:attachment_ids].present?
    broadcast_message(@message, :room_message_create)
  end

  def update
    @message = RoomMessage.find params[:id]
    authorize @message

    @message.update(message_params)

    broadcast_message(@message, :room_message_update) if @message.valid?
  end

  def destroy
    @message = RoomMessage.find params[:id]
    authorize @message

    @message.discard

    broadcast_message(@message, :room_message_destroy) if @message.valid?
  end

  private

  def message_params
    params.require(:room_message).permit(:body)
  end
end
