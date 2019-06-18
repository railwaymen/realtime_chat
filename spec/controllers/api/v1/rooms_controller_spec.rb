require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:user) { create(:user) }

  def expected_response(room)
    {
      id: room.id,
      name: room.name,
      channel_name: room.channel_name
    }
  end

  describe '#index' do
    let(:room) { create(:room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        room

        get :index, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to list all rooms as json' do
        room

        get :index, as: :json
        expect_api_response([expected_response(room)].to_json)
      end

      it 'expects to respond with empty array' do
        get :index, as: :json
        expect_api_response([].to_json)
      end
    end
  end

  describe '#create' do
    let(:params) { attributes_for(:room) }

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
        end.to(change { Room.count }.by(1))

        last_room = user.rooms.last

        expect_api_response(expected_response(last_room).to_json)
      end

      it 'expects to broadcast new room' do
        expect do
          post :create, params: params, as: :json
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end

  describe '#update' do
    let(:room) { create(:room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        put :update, params: { id: room.id, name: 'Conrefence' }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to update room name' do
        expect do
          put :update, params: { id: room.id, name: 'Conference' }, as: :json
        end.to(change { room.reload.name }.to('Conference'))

        expect_api_response(expected_response(room).to_json)
      end

      it 'expects to respond with invalid error' do
        expect do
          put :update, params: { id: room.id, name: '' }, as: :json
        end.not_to(change { room.reload.name })

        expect(response).to have_http_status 422
      end

      it 'expects to broadcast updated room' do
        expect do
          put :update, params: { id: room.id, name: 'Conference' }, as: :json
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end

  describe '#destroy' do
    let!(:room) { create(:room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        delete :destroy, params: { id: room.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to destroy room' do
        expect do
          delete :destroy, params: { id: room.id }, as: :json
        end.to(change { Room.count }.by(-1))

        expect(response).to have_http_status 204
      end

      it 'expects to broadcast destroyed room' do
        expect do
          delete :destroy, params: { id: room.id }, as: :json
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end
end
