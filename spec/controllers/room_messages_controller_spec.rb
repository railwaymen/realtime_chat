# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomMessagesController, type: :controller do
  let(:user) { create(:user_with_rooms) }
  let(:room) { user.rooms.first }

  describe '#create' do
    let(:message_params) { attributes_for(:room_message).merge(room_id: room.id) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        post :create, params: { room_message: message_params }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to create new message' do
        expect do
          post :create, params: { room_message: message_params }
        end.to(change { room.messages.count }.by(1))
      end

      it 'expects to broadcast new message' do
        expect do
          post :create, params: { room_message: message_params }
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end

  describe '#update' do
    let(:message) { create(:room_message, room: room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        put :update, params: { id: message.id, room_message: { body: 'New body' } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to create new message' do
        expect do
          put :update, params: { id: message.id, room_message: { body: 'New body' } }
        end.to(change { message.reload.body }.to('New body'))
      end

      it 'expects not to change body if invalid' do
        expect do
          put :update, params: { id: message.id, room_message: { body: '' } }
        end.not_to(change { message.reload.body })
      end

      it 'expects to broadcast updated message' do
        expect do
          put :update, params: { id: message.id, room_message: { body: 'New body' } }
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end

      it 'expects not to broadcast updated message' do
        expect do
          put :update, params: { id: message.id, room_message: { body: '' } }
        end.not_to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end

  describe '#destroy' do
    let!(:message) { create(:room_message, room: room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        delete :destroy, params: { id: message.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to create new message' do
        expect do
          delete :destroy, params: { id: message.id }
        end.to(change { room.messages.kept.count }.by(-1))
      end

      it 'expects to broadcast deleted message' do
        expect do
          delete :destroy, params: { id: message.id }
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end
end
