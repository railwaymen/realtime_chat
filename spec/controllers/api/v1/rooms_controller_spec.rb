require 'rails_helper'

RSpec.describe Api::V1::RoomsController, type: :controller do
  let(:user) { create(:user_with_rooms) }

  describe '#index' do
    context 'unauthorized' do
      it 'expects to respond with error' do
        get :index, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to list all rooms as json' do
        get :index, as: :json
        expect_success_api_response_for('rooms')
      end

      it 'expects to respond with empty array' do
        Room.destroy_all

        get :index, as: :json
        expect_success_api_response_for('rooms')
      end
    end
  end
end
