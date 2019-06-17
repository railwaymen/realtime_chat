require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  let(:room) { create(:room) }
  let(:user) { room.user }

  def expected_response(message)
    {
      id: message.id,
      user_id: message.user_id,
      body: message.body,
      user: {
        username: message.user.username
      }
    }
  end

  describe '#index' do
    let(:message) { create(:room_message, user: user, room: room) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        message

        get :index, params: { room_id: room.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to list all room messages as json' do
        message

        get :index, params: { room_id: room.id }, as: :json
        expect_api_response([expected_response(message)].to_json)
      end

      it 'expects to respond with empty array' do
        get :index, params: { room_id: room.id }, as: :json
        expect_api_response([].to_json)
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

      it 'expects to create new message' do
        expect do
          post :create, params: params, as: :json
        end.to(change { room.messages.count }.by(1))

        last_message = room.messages.last

        expect_api_response(expected_response(last_message).to_json)
      end

      it 'expects to broadcast new message' do
        expect do
          post :create, params: params, as: :json
        end.to have_broadcasted_to(room).from_channel(RoomChannel)
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

      it 'expects to update message body' do
        expect do
          put :update, params: { room_id: room.id, id: message.id, body: 'How are you?' }, as: :json
        end.to(change { message.reload.body }.to('How are you?'))

        expect_api_response(expected_response(message).to_json)
      end

      it 'expects to respond with invalid error' do
        expect do
          put :update, params: { room_id: room.id, id: message.id, body: '' }, as: :json
        end.not_to(change { message.reload.body })

        expect(response).to have_http_status 422
      end

      it 'expects to broadcast updated message' do
        expect do
          put :update, params: { room_id: room.id, id: message.id, body: 'How are you?' }, as: :json
        end.to have_broadcasted_to(room).from_channel(RoomChannel)
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

      it 'expects to broadcast destroyed message' do
        expect do
          delete :destroy, params: { room_id: room.id, id: message.id }, as: :json
        end.to have_broadcasted_to(room).from_channel(RoomChannel)
      end
    end
  end
end