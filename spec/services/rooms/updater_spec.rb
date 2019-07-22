# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::Updater do
  let(:user) { create(:user) }
  let(:room) { create(:room, user: user) }

  describe '#update_room' do
    it 'expects to update room object' do
      expect do
        Rooms::Updater.new(room_params: { name: 'New name' }, room: room, user: user).call
      end.to(change { room.reload.name }.to('New name'))
    end

    it 'expects not to update room without name' do
      expect do
        Rooms::Updater.new(room_params: { name: '' }, room: room, user: user).call
      end.not_to(change { room.reload.name })
    end
  end

  describe '#update_rooms_users' do
    let(:closed_room) { create(:room_with_participants, user: user) }

    it 'expects to delete excluded users' do
      refreshed_users_ids = closed_room.users.limit(2).pluck(:id)

      expect do
        Rooms::Updater.new(
          room_params: {},
          users_ids: refreshed_users_ids.join(','),
          user: user,
          room: closed_room
        ).call
      end.to(change { RoomsUser.count }.by(-1))
    end

    it 'expects to add new users' do
      room_users_ids = closed_room.users.pluck(:id)
      room_users_ids.push(create(:user).id)

      expect do
        Rooms::Updater.new(
          room_params: {},
          users_ids: room_users_ids.join(','),
          user: user,
          room: closed_room
        ).call
      end.to(change { RoomsUser.count }.by(1))
    end
  end
end
