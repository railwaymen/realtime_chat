# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :user
  belongs_to :room_message, optional: true

  mount_uploader :file, AttachmentUploader

  validates :file, presence: true

  before_save :save_content_type_and_size_in_model

  def serialized
    Api::V1::AttachmentSerializer.render_as_hash(self)
  end

  private

  def save_content_type_and_size_in_model
    self.content_type = file.content_type if file.content_type
    self.file_size = file.size
  end
end
