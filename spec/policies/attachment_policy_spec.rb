# frozen_string_literal: true

describe AttachmentPolicy do
  subject { described_class }
  let(:user) { create(:user) }

  permissions :destroy? do
    it 'grants access for owner' do
      attachment = create(:attachment, user: user)
      expect(subject).to permit(user, attachment)
    end

    it 'denies access for other users' do
      attachment = create(:attachment)
      expect(subject).to_not permit(user, attachment)
    end
  end
end
