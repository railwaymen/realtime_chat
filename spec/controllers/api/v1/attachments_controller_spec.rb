# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  def expected_response(attachment)
    {
      id: attachment.id,
      content_type: attachment.content_type,
      file_size: attachment.file_size,
      file_identifier: attachment.file_identifier,
      url: attachment.file.url
    }
  end

  describe '#create' do
    let(:params) { { user_id: user.id } }

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
          image_path = Rails.root.join('spec', 'support', 'attachments', 'image.png')
          image = Rack::Test::UploadedFile.new(image_path, 'image/png')
          post :create, params: { file: image }, as: :json
        end.to(change { user.attachments.count }.by(1))

        attachment = user.attachments.last

        expect_api_response(expected_response(attachment).to_json)
      end
    end
  end

  describe '#destroy' do
    let(:attachment) { create :attachment, user: user }

    context 'unauthorized' do
      it 'expects to respond with error' do
        delete :destroy, params: { id: attachment.id }, as: :json
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      before(:each) { sign_in user }

      it 'expects to destroy attachment' do
        attachment

        expect do
          delete :destroy, params: { id: attachment.id }, as: :json
        end.to(change { user.attachments.count }.by(-1))

        expect(response).to have_http_status 204
      end
    end
  end
end
