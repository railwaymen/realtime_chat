# frozen_string_literal: true

require 'rails_helper'

describe RoomMessagesConcern, type: :controller do
  controller(ApplicationController) do
    include RoomMessagesConcern
  end

  it '#assign_attachments' do
    user = create(:user)
    message = create(:room_message, user: user)
    attachment = create(:attachment, user: user)

    sign_in user

    controller.send(:assign_attachments, message, [attachment.id])

    expect(attachment.reload.room_message_id).to eql(message.id)
  end
end
