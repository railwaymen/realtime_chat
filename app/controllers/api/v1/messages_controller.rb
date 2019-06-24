# frozen_string_literal: true

module Api
  module V1
    class MessagesController < Api::V1::BaseController
      before_action :authenticate_user!
      MESSAGES_LIMIT = 10

      def index
        @messages = room.messages.includes(:user).order(id: :desc).limit(MESSAGES_LIMIT)
        @messages = @messages.where('id < ?', params[:last_id]) if params[:last_id].present?
        respond_with @messages
      end

      def create
        @message = room.messages.build(message_params.merge(user: current_user))
        authorize @message

        @message.save

        RoomChannel.broadcast_to(@message.room, data: @message, type: :create) if @message.valid?
        respond_with @message
      end

      def update
        @message = RoomMessage.find(params[:id])
        authorize @message

        @message.update(message_params)
        RoomChannel.broadcast_to(@message.room, data: @message, type: :update) if @message.valid?
        respond_with @message
      end

      def destroy
        @message = RoomMessage.find(params[:id])
        authorize @message

        @message.discard
        RoomChannel.broadcast_to(@message.room, data: @message, type: :destroy)
        head :no_content
      end

      private

      def room
        @room ||= policy_scope(Room).kept.find(params[:room_id])
      end

      def message_params
        params.permit(:body)
      end
    end
  end
end
