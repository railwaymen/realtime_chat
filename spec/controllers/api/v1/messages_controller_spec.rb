require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  let(:room) { create(:room) }
  let(:user) { room.user }

  describe '#index' do
    context 'unauthorized' do
      it 'expects to respond with error' do
        get :index, params: { room_id: room.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to list all room messages as json' do
        get :index, params: { room_id: room.id }, as: :json
        expect_success_api_response_for('messages')
      end

      it 'expects to respond with empty array' do
        RoomMessage.destroy_all

        get :index, params: { room_id: room.id }, as: :json
        expect_success_api_response_for('messages')
      end
    end
  end

  describe '#create' do
    let(:params) { attributes_for(:room_message).merge(room_id: room.id) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        post :create, params: params, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to create new room' do
        expect do
          post :create, params: params, as: :json
        end.to(change { room.messages.count }.by(1))

        expect_success_api_response_for('message')
      end
    end
  end

  describe '#update' do
    let(:message) { create(:room_message, room: room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        put :update, params: { room_id: room.id, id: message.id, body: 'How are you?' }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to update room name' do
        expect do
          put :update, params: { room_id: room.id, id: message.id, body: 'How are you?' }, as: :json
        end.to(change { message.reload.body }.to('How are you?'))

        expect_success_api_response_for('message')
      end

      it 'expects to respond with invalid error' do
        expect do
          put :update, params: { room_id: room.id, id: message.id, body: '' }, as: :json
        end.not_to(change { message.reload.body })

        expect(response).to have_http_status 422
      end
    end
  end

  describe '#destroy' do
    let!(:message) { create(:room_message, room: room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        delete :destroy, params: { room_id: room.id, id: message.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to destroy message' do
        expect do
          delete :destroy, params: { room_id: room.id, id: message.id }, as: :json
        end.to(change { room.messages.count }.by(-1))

        expect(response).to have_http_status 204
      end
    end
  end
end