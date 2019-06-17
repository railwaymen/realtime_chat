# frozen_string_literal: true

module Api
  module V1
    class MessagesController < Api::V1::BaseController
      before_action :authenticate_user!
      
      def index
        @messages = room.messages.includes(:user).order(created_at: :asc)
        respond_with @messages
      end

      def create
        @message = room.messages.create(message_params.merge(user: current_user))
        RoomChannel.broadcast_to @message.room, @message if @message.valid?
        respond_with @message
      end

      def update
        @message = room.messages.find(params[:id])
        @message.update(message_params)
        respond_with @message
      end

      def destroy
        @message = room.messages.find(params[:id])
        @message.destroy!
        head :no_content
      end

      private

      def room
        @room ||= Room.find(params[:room_id])
      end

      def message_params
        params.permit(:body)
      end
    end
  end
end
