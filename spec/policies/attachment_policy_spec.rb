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

  describe AttachmentPolicy::Scope do
    it 'returns accessible attachments' do
      attachment = create(:attachment, user: user)
      create(:attachment)

      rooms = AttachmentPolicy::Scope.new(user, Attachment).resolve
      expect(rooms).to contain_exactly(attachment)
    end
  end
end
