# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::Creator do
  let(:user) { create(:user) }

  describe '#call' do
    it 'expects to return persisted Room object' do
      result = Rooms::Creator.new(room_params: attributes_for(:room, public: true), user: user).call
      expect(result).to be_a(Room).and be_persisted
    end

    it 'expects to return non persisted Room object' do
      result = Rooms::Creator.new(room_params: { name: '' }, user: user).call
      expect(result).to be_a(Room).and be_new_record
    end
  end

  describe '#create_room' do
    it 'expects to create public new room' do
      expect do
        Rooms::Creator.new(room_params: attributes_for(:room, public: true), user: user).call
      end.to(change { Room.count }.by(1))
    end

    it 'expects to create private room with owner as participant' do
      expect do
        Rooms::Creator.new(room_params: attributes_for(:room, public: false), user: user).call
      end.to(change { RoomsUser.count }.by(1))
    end

    it 'expects not to create room without name' do
      expect do
        Rooms::Creator.new(room_params: { name: '' }, user: user).call
      end.not_to(change { Room.count })
    end
  end

  describe '#create_rooms_users' do
    let(:participants_ids) { [create(:user), create(:user)].map(&:id) }

    it 'expects not to create rooms_users if public room' do
      expect do
        Rooms::Creator.new(room_params: attributes_for(:room, public: true), user: user).call
      end.not_to(change { RoomsUser.count })
    end

    it 'expects to create rooms_users for all participants' do
      expect do
        Rooms::Creator.new(
          room_params: attributes_for(:room, public: false),
          users_ids: participants_ids.join(','),
          user: user
        ).call
      end.to(change { RoomsUser.count }.by(participants_ids.length + 1)) # participants + owner
    end

    it 'expects not to create rooms_users if room is invalid' do
      expect do
        Rooms::Creator.new(
          room_params: { name: '' },
          users_ids: participants_ids.join(','),
          user: user
        ).call
      end.not_to(change { RoomsUser.count })
    end
  end
end
