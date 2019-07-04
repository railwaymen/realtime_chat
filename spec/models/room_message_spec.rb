# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomMessage, type: :model do
  it 'updates last_message_at in room' do
    room = create(:room)
    message = create(:room_message, room: room)

    expect(room.reload.last_message_at.to_i).to eql(message.created_at.to_i)
  end

  describe '#edited?' do
    let(:message) { create(:room_message) }

    it 'expects to return false' do
      expect(message.edited?).to eq false
    end

    it 'expects to return true' do
      message.update(body: 'New content')
      expect(message.edited?).to eq true
    end
  end
end
