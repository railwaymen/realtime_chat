# frozen_string_literal: true

module Api
  module V1
    class AttachmentSerializer < Blueprinter::Base
      identifier :id

      fields :content_type, :file_size, :created_at, :file_identifier

      field :url do |attachment|
        attachment.file.url
      end

      field :thumb_url do |attachment|
        attachment.file.thumb.url
      end
    end
  end
end
