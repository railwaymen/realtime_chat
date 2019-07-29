# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  def expected_response(user)
    {
      id: user.id,
      username: user.username,
      email: user.email,
      avatar_url: user.avatar.thumb.url
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
      it 'expects to list all users as json' do
        sign_in user

        get :index, as: :json
        expect_api_response([expected_response(user)].to_json)
      end
    end
  end

  describe '#update' do
    context 'unauthorized' do
      it 'expects to respond with error' do
        put :update, params: {}, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      it 'expects to update message body' do
        sign_in user

        avatar_src = Rails.root.join('spec', 'support', 'attachments', 'image.png')
        avatar = Rack::Test::UploadedFile.new(avatar_src, 'image/png')

        expect do
          put :update, params: { avatar: avatar }, as: :json
        end.to(change { user.reload.avatar_url }.to("/uploads/user/avatar/#{user.id}/image.png"))

        expect_api_response(expected_response(user).to_json)
      end

      it 'expects to respond with invalid error' do
        sign_in user

        avatar_src = Rails.root.join('spec', 'support', 'attachments', 'text.txt')
        avatar = Rack::Test::UploadedFile.new(avatar_src, 'text/plain')

        expect do
          put :update, params: { avatar: avatar }, as: :json
        end.not_to(change { user.reload.avatar_url })

        expect(response).to have_http_status 422
      end
    end
  end

  describe '#profile' do
    context 'unauthorized' do
      it 'expects to respond with error' do
        get :profile, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      it 'expects to current user as json' do
        current_date = Time.current.to_s
        user = create(:user, rooms_activity: { '1' => current_date })
        sign_in user

        profile_response = expected_response(user).merge(
          rooms_activity: { '1' => current_date }
        )

        get :profile, as: :json
        expect_api_response(profile_response.to_json)
      end
    end
  end
end
