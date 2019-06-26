# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RoomsUsersController, type: :controller do
  let(:room) { create(:room) }
  let(:user) { room.user }

  def expected_response(rooms_user)
    {
      id: rooms_user.id,
      room_id: rooms_user.room_id,
      user_id: rooms_user.user_id,
      user: {
        id: rooms_user.user.id,
        username: rooms_user.user.username,
        email: rooms_user.user.email
      }
    }
  end

  describe '#index' do
    let(:rooms_user) { create(:rooms_user, user: user, room: room) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        rooms_user

        get :index, params: { room_id: room.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to list all rooms_users in room as json' do
        rooms_user

        get :index, params: { room_id: room.id }, as: :json
        expect_api_response([expected_response(rooms_user)].to_json)
      end

      it 'expects to respond with empty array' do
        get :index, params: { room_id: room.id }, as: :json
        expect_api_response([].to_json)
      end
    end
  end

  describe '#create' do
    let(:params) { { room_id: room.id, user_id: user.id } }

    context 'unauthorized' do
      it 'expects to respond with error' do
        post :create, params: params, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to create new rooms_user' do
        expect do
          post :create, params: params, as: :json
        end.to(change { room.rooms_users.count }.by(1))

        last_rooms_user = room.rooms_users.last

        expect_api_response(expected_response(last_rooms_user).to_json)
      end
    end
  end

  describe '#destroy' do
    let(:rooms_user) { create(:rooms_user, room: room, user: user) }

    context 'unauthorized' do
      it 'expects to respond with error' do
        delete :destroy, params: { id: rooms_user.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to destroy rooms_users' do
        rooms_user

        expect do
          delete :destroy, params: { room_id: room.id, id: rooms_user.id }, as: :json
        end.to(change { room.rooms_users.count }.by(-1))

        expect(response).to have_http_status 204
      end
    end
  end
end
