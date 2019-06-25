describe RoomMessagePolicy do
  subject { described_class }
  let(:user) { create(:user) }

  permissions :create? do
    it 'grants access to public room' do
      room = create(:room, public: true)
      rooms_message = create(:rooms_user, user: user, room: room)
      message = create(:room_message, user: user, room: room)
      expect(subject).to permit(user, message)
    end

    it 'grants access to privare room when users is assigned' do
      room = create(:room, public: false)
      rooms_message = create(:rooms_user, user: user, room: room)
      message = create(:room_message, user: user, room: room)
      expect(subject).to permit(user, message)
    end

    it 'denies access to private room for other users' do
      room = create(:room, public: false)
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
end
