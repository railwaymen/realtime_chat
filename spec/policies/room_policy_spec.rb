# frozen_string_literal: true

describe RoomPolicy do
  subject { described_class }
  let(:user) { create(:user) }

  permissions :show? do
    it 'grants access to public public' do
      room = create(:room)
      expect(subject).to permit(user, room)
    end

    it 'grants access to private room when users is assigned' do
      room = create(:room, public: false)
      create(:rooms_user, user: user, room: room)
      expect(subject).to permit(user, room)
    end

    it 'denies access to private room for other users' do
      room = create(:room, public: false)
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
  end

  describe RoomPolicy::Scope do
    it 'returns accessible rooms' do
      public_room = create(:room, public: true)
      private_room1 = create(:room, public: false)
      create(:room, public: false)
      create(:rooms_user, room: private_room1, user: user)

      rooms = RoomPolicy::Scope.new(user, Room).resolve
      expect(rooms).to contain_exactly(public_room, private_room1)
    end
  end
end
