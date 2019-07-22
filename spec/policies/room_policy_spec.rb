# frozen_string_literal: true

describe RoomPolicy do
  subject { described_class }
  let(:user) { create(:user) }

  permissions :show? do
    it 'grants access to closed room' do
      room = create(:room)
      expect(subject).to permit(user, room)
    end

    it 'grants access to closed room when users is assigned' do
      room = create(:room, type: :closed)
      create(:rooms_user, user: user, room: room)
      expect(subject).to permit(user, room)
    end

    it 'denies access to closed room for other users' do
      room = create(:room, type: :closed)
      expect(subject).to_not permit(user, room)
    end
  end

  permissions :update?, :edit?, :destroy? do
    it 'grants access for owner' do
      room = create(:room, user: user)
      expect(subject).to permit(user, room)
    end

    it 'denies access for other users' do
      room = create(:room)
      expect(subject).to_not permit(user, room)
    end

    it 'denies access for direct room' do
      room = create(:room, user: user, type: :direct)
      expect(subject).to_not permit(user, room)
    end
  end

  describe RoomPolicy::Scope do
    it 'returns accessible rooms' do
      open_room = create(:room, type: :open)
      closed_room1 = create(:room, type: :closed)
      create(:room, type: :closed)
      create(:rooms_user, room: closed_room1, user: user)

      rooms = RoomPolicy::Scope.new(user, Room).resolve
      expect(rooms).to contain_exactly(open_room, closed_room1)
    end
  end
end
