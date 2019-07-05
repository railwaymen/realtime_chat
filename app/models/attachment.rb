# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :user
  belongs_to :room_message, optional: true

  mount_uploader :file, AttachmentUploader

  validates :file, presence: true

  def serialized
    Api::V1::AttachmentSerializer.render_as_hash(self)
  end
end
