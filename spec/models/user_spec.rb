# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomMessage, type: :model do
  it 'update_room_activity' do
    room = create(:room)
    user = create(:user)

    user.update_room_activity(room)

    last_activity = Time.parse(user.rooms_activity[room.id.to_s])
    expect(last_activity).to be_within(1.second).of(Time.current)
  end
end
