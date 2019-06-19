require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  def expected_response(room)
    {
      id: user.id,
      username: user.username,
      email: room.email
    }
  end

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
        expect_api_response([expected_response(user)].to_json)
      end
    end
  end
end
