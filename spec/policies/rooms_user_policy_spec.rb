# frozen_string_literal: true

describe RoomsUserPolicy do
  subject { described_class }
  let(:user) { create(:user) }

  permissions :create?, :destroy? do
    it 'grants access for owner' do
      room = create(:room, user: user, public: false)
      rooms_user = create(:rooms_user, user: user, room: room)
      expect(subject).to permit(user, rooms_user)
    end

    it 'denies access for other users' do
      room = create(:room, public: false)
      rooms_user = create(:rooms_user, user: user, room: room)
      expect(subject).to_not permit(user, rooms_user)
    end
  end
end
