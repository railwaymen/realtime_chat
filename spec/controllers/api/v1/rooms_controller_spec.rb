# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:user) { create(:user) }

  def expected_response(room)
    {
      id: room.id,
      name: room.name,
      description: room.description,
      channel_name: room.channel_name,
      deleted: room.discarded?,
      user_id: room.user_id,
      type: room.type,
      last_message_at: nil,
      participants: room.users.map { |u| u.slice(:email, :id, :username).merge(avatar_url: u.avatar.thumb.url) },
      room_path: room_path(room)
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

      it 'expects to list direct rooms as json' do
        direct_room = create :room, type: :direct, user: user
        user2 = create :user, username: 'User 2'
        create :rooms_user, room: direct_room, user: direct_room.user
        create :rooms_user, room: direct_room, user: user2

        get :index, as: :json
        expect_api_response([expected_response(direct_room)].to_json)
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

      it 'expects to create new rooms_user for owner' do
        expect do
          post :create, params: params.merge(type: :closed), as: :json
        end.to(change { RoomsUser.count }.by(1))

        expect(RoomsUser.last.user).to eql(user)
      end

      it 'expects to respond with error if empty name' do
        expect do
          post :create, params: { name: '' }, as: :json
        end.not_to(change { Room.count })

        expect(response).to have_http_status 422
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
        delete :destroy, params: { id: room.id }, as: :json

        expect(room.reload.discarded?).to be_truthy
        expect(response).to have_http_status 204
      end

      it 'expects to broadcast destroyed room' do
        expect do
          delete :destroy, params: { id: room.id }, as: :json
        end.to have_broadcasted_to(:app).from_channel(AppChannel)
      end
    end
  end

  describe '#update_activity' do
    let!(:room) { create(:room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        post :update_activity, params: { id: room.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to update room activity' do
        allow(subject.current_user).to receive(:update_room_activity).with(room)
        post :update_activity, params: { id: room.id }, as: :json

        expect(subject.current_user).to have_received(:update_room_activity).with(room)
        expect(response).to have_http_status 204
      end
    end
  end
end
