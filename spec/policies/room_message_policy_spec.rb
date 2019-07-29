# frozen_string_literal: true

describe RoomMessagePolicy do
  subject { described_class }
  let(:user) { create(:user) }

  permissions :create? do
    it 'grants access to open room' do
      room = create(:room, type: :open)
      create(:rooms_user, user: user, room: room)
      message = create(:room_message, user: user, room: room)
      expect(subject).to permit(user, message)
    end

    it 'grants access to closed room when users is assigned' do
      room = create(:room, type: :closed)
      create(:rooms_user, user: user, room: room)
      message = create(:room_message, user: user, room: room)
      expect(subject).to permit(user, message)
    end

    it 'denies access to closed room for other users' do
      room = create(:room, type: :closed)
      message = create(:room_message, user: user, room: room)
      expect(subject).to_not permit(user, message)
    end
  end

  permissions :update?, :edit?, :destroy? do
    it 'grants access for owner' do
      message = create(:room_message, user: user)
      expect(subject).to permit(user, message)
    end

    it 'denies access for other users' do
      message = create(:room_message)
      expect(subject).to_not permit(user, message)
    end
  end

  describe RoomMessagePolicy::Scope do
    it 'returns accessible messages' do
      closed_room1 = create(:room, type: :closed)
      closed_room2 = create(:room, type: :closed)
      create(:rooms_user, room: closed_room1, user: user)

      message1 = create(:room_message, room: closed_room1)
      create(:room_message, room: closed_room2)

      messages = RoomMessagePolicy::Scope.new(user, RoomMessage).resolve
      expect(messages).to contain_exactly(message1)
    end
  end
end
