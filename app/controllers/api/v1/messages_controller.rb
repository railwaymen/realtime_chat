# frozen_string_literal: true

module Api
  module V1
    class MessagesController < Api::V1::BaseController
      include RoomMessagesConcern
      before_action :authenticate_user!
      MESSAGES_LIMIT = 10

      def index
        @messages = room.messages.includes(:user).order(id: :asc).limit(MESSAGES_LIMIT)
        @messages = @messages.where('id < ?', params[:last_id]) if params[:last_id].present?
        
        render json: Api::V1::MessageSerializer.render(@messages), status: 200
      end

      def create
        @message = room.messages.build(message_params.merge(user: current_user))
        authorize @message

        if @message.save
          broadcast_message(@message, :room_message_create)
          render json: @message.serialized, status: 200
        else
          render json: Api::V1::ErrorSerializer.render_as_hash(@message), status: 422
        end
      end

      def update
        @message = RoomMessage.find(params[:id])
        authorize @message

        if @message.update(message_params)
          broadcast_message(@message, :room_message_update)
          render json: @message.serialized, status: 200
        else
          render json: Api::V1::ErrorSerializer.render_as_hash(@message), status: 422
        end
      end

      def destroy
        @message = RoomMessage.find(params[:id])
        authorize @message

        @message.discard
        broadcast_message(@message, :room_message_destroy) if @message.valid?

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
