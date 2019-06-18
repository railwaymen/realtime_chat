require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let(:user) { create(:user_with_rooms) }

  describe '#index' do
    context 'unauthorized' do
      it 'expects to respond with error' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to render view' do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#new' do
    context 'unauthorized' do
      it 'expects to respond with error' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to render view' do
        get :new
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#create' do
    let(:room_params) { { room: attributes_for(:room) } }

    context 'unauthorized' do
      it 'expects to respond with error' do
        post :create, params: room_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to create new room' do
        expect do
          post :create, params: room_params
        end.to(change { Room.count }.by(1))

        expect(response).to redirect_to rooms_path
      end

      it 'expects to respond with error due to invalid params' do
        expect do
          post :create, params: { room: { name: '' } }
        end.not_to(change { Room.count })

        expect(response).to render_template 'new'
      end
    end
  end

  describe '#edit' do
    let(:room) { user.rooms.first }

    context 'unauthorized' do
      it 'expects to respond with error' do
        get :edit, params: { id: room.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to render view' do
        get :edit, params: { id: room.id }
        expect(response).to have_http_status(200)
      end

      it 'expects to raise not_found for foreign room' do
        other_room = create(:room)

        expect do
          get :edit, params: { id: other_room.id }
        end.to(raise_exception ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#update' do
    let(:room) { user.rooms.first }

    context 'unauthorized' do
      it 'expects to respond with error' do
        put :update, params: { id: room.id, room: { name: 'New name' } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to change room name' do
        expect do
          put :update, params: { id: room.id, room: { name: 'New name' } }
        end.to(change { room.reload.name }.to('New name'))

        expect(response).to redirect_to rooms_path
      end

      it 'expects to respond with error due to invalid params' do
        expect do
          put :update, params: { id: room.id, room: { name: '' } }
        end.not_to(change { room.reload.name })

        expect(response).to render_template 'edit'
      end

      it 'expects to raise not_found for foreign room' do
        other_room = create(:room)

        expect do
          put :update, params: { id: other_room.id, room: { name: 'New name' } }
        end.to(raise_exception ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#destroy' do
    let(:room) { user.rooms.first }

    context 'unauthorized' do
      it 'expects to respond with error' do
        delete :destroy, params: { id: room.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to discard room' do
        expect do
          delete :destroy, params: { id: room.id }
        end.to(change { Room.kept.count }.by(-1))

        expect(response).to redirect_to rooms_path
      end

      it 'expects to raise not_found for foreign room' do
        other_room = create(:room)

        expect do
          delete :destroy, params: { id: other_room.id }
        end.to(raise_exception ActiveRecord::RecordNotFound)
      end
    end
  end
end
